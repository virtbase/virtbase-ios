//
//  ServerInformationView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 14.03.26.
//

/*
 *   Copyright (c) 2026 Karl Ehrlich
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import SwiftUI

struct ServerInformationView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: ServerInformationViewModel = .init()
    
    var server: Server
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded, let information = viewModel.information {
                    ForEach(information.allocations) { allocation in
                        Section("Zuweisung (Familie \(allocation.subnet.family))") {
                            HStack {
                                Text("Addresse")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                Spacer(minLength: 0)
                                Text(allocation.subnet.address)
                            }
                            
                            HStack {
                                Text("Gateway")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                Spacer(minLength: 0)
                                Text(allocation.subnet.gateway)
                            }
                        }
                    }
                    
                    Section("Node") {
                        HStack {
                            Text("Name")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.node.name)
                        }
                        
                        HStack {
                            Text("CPU")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.node.processor)
                        }
                        
                        HStack {
                            Text("RAM")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.node.memory)
                        }
                        
                        HStack {
                            Text("Festplatte")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.node.storage)
                        }
                        
                    }
                    
                    Section("Rechenzentrum") {
                        HStack {
                            Text("Name")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.datacenter.name)
                        }
                        
                        HStack {
                            Text("Land")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(information.datacenter.country)
                        }
                    }
                } else {
                    HandlerView(status: viewModel.status)
                }
            }
            .navigationTitle("Details")
            .textSelection(.enabled)
            .textSelectionAffinity(.upstream)
            .lineLimit(1)
        }
        .refreshable {
            Upstream.refresh()
        }
        .task {
            await viewModel.fetch(
                session: authentication.session,
                server: server
            )
        }
        .onReceive(Upstream.refreshed) { _ in
            Task {
                await viewModel.fetch(
                    session: authentication.session,
                    server: server
                )
            }
        }
    }
}
