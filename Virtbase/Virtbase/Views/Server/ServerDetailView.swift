//
//  ServerDetailView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 18.02.26.
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
import Combine

struct ServerDetailView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: ServerStateViewModel = .init()
    
    @State private
    var editableName: String = ""
    
    @State private
    var displayEdit: Bool = false
    
    @State private
    var displayConsole: Bool = false
    
    @State private
    var displayErasure: Bool = false
    
    var server: Server
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    ServerChartView(
                        server: server,
                        features: [
                            .processor,
                            .memory,
                            .networkIncoming,
                            .networkOutgoing,
                            .diskRead,
                            .diskWrite
                        ]
                    ) .frame(height: 250)
                    
                    HStack {
                        if let status = viewModel.state?.status {
                            ServerStatusView(status: status)
                        }
                        
                        Spacer(minLength: 0)
                        
                        if let task = viewModel.state?.task {
                            ServerTaskView(task: task)
                            ProgressView()
                                .controlSize(.mini)
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        ServerInformationView(server: server)
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet.below.rectangle")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Details")
                        }
                    }
                }
                
                Section("Optionen") {
                    NavigationLink {
                        ServerFirewallView(server: server)
                    } label: {
                        HStack {
                            Image(systemName: "shield.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Firewall")
                        }
                    }
                    
                    NavigationLink {
                        ServerBackupsView(server: server)
                    } label: {
                        HStack {
                            Image(systemName: "cylinder.split.1x2.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Backups")
                        }
                    }
                    
                    NavigationLink {
                        ServerRdnsView(server: server)
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("rDNS")
                        }
                    }
                }
                
            }
            .navigationTitle(server.name)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Bearbeiten") {
                        displayEdit.toggle()
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        displayConsole.toggle()
                    } label: {
                        Image(systemName: "apple.terminal.on.rectangle")
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        switch viewModel.state?.status {
                        case .running:
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .stop
                                    )
                                }
                            } label: {
                                Label(
                                    "Stoppen",
                                    systemImage: "stop.fill"
                                )
                            }
                            
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .pause
                                    )
                                }
                            } label: {
                                Label(
                                    "Pausieren",
                                    systemImage: "pause.fill"
                                )
                            }
                            
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .suspend
                                    )
                                }
                            } label: {
                                Label(
                                    "Suspendieren",
                                    systemImage: "moon.fill"
                                )
                            }
                            
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .reboot
                                    )
                                }
                            } label: {
                                Label(
                                    "Neustarten",
                                    systemImage: "arrow.clockwise"
                                )
                            }
                            
                        case .stopped:
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .start
                                    )
                                }
                            } label: {
                                Label(
                                    "Starten",
                                    systemImage: "play.fill"
                                )
                            }
                        case .paused, .suspended:
                            Button {
                                Task {
                                    try await ServerState.update(
                                        session: authentication.session,
                                        server: server,
                                        status: .resume
                                    )
                                }
                            } label: {
                                Label(
                                    "Fortfahren",
                                    systemImage: "playpause.fill"
                                )
                            }
                        case .unknown, nil:
                            EmptyView()
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            displayErasure.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Zurücksetzen")
                            }
                        }
                    } label: {
                        Image(systemName: "power")
                    }
                }
            }
        }
        .alert("Name Bearbeiten", isPresented: $displayEdit) {
            TextField(server.name, text: $editableName)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .monospaced()
            
            Button("Abbrechen", role: .cancel) {}
            Button("Fertig", role: .confirm) {
                Task {
                    try await Server.rename(
                        session: authentication.session,
                        server: server,
                        name: editableName
                    )
                }
            }
            // Disable submission, if the cleaned server name is more than 64, or less than 1 character
            .disabled(!((1...64).contains(editableName.trimmingCharacters(in: .whitespacesAndNewlines).count)))
        } message: {
            Text("Lege einen neuen Namen für deinen Server fest. Der Name darf nicht leer sein.")
        }
        .alert("Server '\(server.name)' löschen?", isPresented: $displayErasure) {
            Button("Abbrechen", role: .cancel) {}
            Button("Löschen", role: .destructive) {
                Task {
                    try await ServerState.update(
                        session: authentication.session,
                        server: server,
                        status: .reset
                    )
                }
            }
        } message: {
            Text("Alle Daten auf dem Server werden gelöscht. Dies lässt sich nicht rückgangig machen.")
        }
        .fullScreenCover(isPresented: $displayConsole) {
            ServerConsoleView(server: server)
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
