//
//  ServerRowView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 17.02.26.
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

struct ServerRowView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: ServerStateViewModel = .init()
    
    var server: Server
    
    var body: some View {
        VStack(spacing: 10) {
            
            ServerChartView(
                server: server,
                features: [
                    .processor,
                    .memory,
                    .networkIncoming,
                    .diskWrite
                ]
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            
            Divider()
            
            NavigationLink {
                ServerDetailView(server: server)
            } label: {
                VStack(alignment: .leading) {
                    Text(server.name)
                        .monospaced()
                        .lineLimit(1)
                   
                    HStack {
                        if let status = viewModel.state?.status {
                            ServerStatusView(status: status)
                                .font(.subheadline)
                        }
                        
                        if let task = viewModel.state?.task {
                            ProgressView()
                                .controlSize(.mini)
                            
                            ServerTaskView(task: task)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .frame(height: 220)
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
