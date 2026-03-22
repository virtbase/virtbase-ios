//
//  ServerRdnsView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 19.03.26.
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

struct ServerRdnsView: View {
    
    @EnvironmentObject private var authentication: AuthenticationModel
    
    @StateObject private var viewModel: ServerRdnsViewModel = .init()
    
    var server: Server
    
    @State private var displayCreation = false
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded,
                   let records = viewModel.records {
                    
                    Section("Einträge") {
                        if records.isEmpty {
                            Text("Keine Einträge")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(10)
                        }
                        
                        ForEach(records) { record in
                            NavigationLink {
                                RdnsRecordEditorView(
                                    server: server,
                                    record: record,
                                    viewModel: viewModel,
                                    session: authentication.session
                                )
                            } label: {
                                RdnsRecordRow(record: record)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteRecord(
                                            session: authentication.session,
                                            server: server,
                                            record: record
                                        )
                                    }
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                } else {
                    HandlerView(status: viewModel.status)
                }
            }
            .navigationTitle("rDNS")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        displayCreation = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $displayCreation) {
            RdnsRecordCreationSheet(
                server: server,
                viewModel: viewModel,
                session: authentication.session
            )
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
