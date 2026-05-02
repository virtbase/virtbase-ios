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
    var displayPasswordReset: Bool = false

    @State private
    var passwordResetUsername: String = "root"

    @State private
    var passwordResetPassword: String = ""
    
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
                ToolbarItem(placement: .primaryAction) {
                    Button("Bearbeiten") {
                        displayEdit.toggle()
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .primaryAction)
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        displayConsole.toggle()
                    } label: {
                        Image(systemName: "apple.terminal.on.rectangle")
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .primaryAction)
                
                ToolbarItem(placement: .primaryAction) {
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
                        
                        Button {
                            passwordResetUsername = "root"
                            passwordResetPassword = ""
                            displayPasswordReset.toggle()
                        } label: {
                            Label(
                                "Passwort zurücksetzen",
                                systemImage: "key.fill"
                            )
                        }

                        Button {
                            Task {
                                try await ServerState.update(
                                    session: authentication.session,
                                    server: server,
                                    status: .reset
                                )
                            }
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
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
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
        .alert("Passwort zurücksetzen", isPresented: $displayPasswordReset) {
            TextField("Benutzername", text: $passwordResetUsername)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled()
                .monospaced()

            SecureField("Passwort", text: $passwordResetPassword)
                #if os(iOS)
                .textInputAutocapitalization(.never)
                #endif
                .autocorrectionDisabled()

            Button("Abbrechen", role: .cancel) {}
            Button("Zurücksetzen", role: .destructive) {
                Task {
                    try await Server.resetPassword(
                        session: authentication.session,
                        server: server,
                        username: passwordResetUsername.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ),
                        password: passwordResetPassword
                    )
                }
            }
            .disabled(!isPasswordResetValid)
        } message: {
            Text("Lege ein neues Passwort für den angegebenen Benutzer fest.")
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $displayConsole) {
            ServerConsoleView(server: server)
        }
        #elseif os(macOS)
        .sheet(isPresented: $displayConsole) {
            ServerConsoleView(server: server)
        }
        #endif
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

    private var isPasswordResetValid: Bool {
        let username = passwordResetUsername.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return (1...64).contains(username.count)
            && !passwordResetPassword.isEmpty
    }
}
