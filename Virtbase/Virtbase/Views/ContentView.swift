//
//  ContentView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 12.02.26.
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

struct ContentView: View {
    
    @Environment(\.openURL) private
    var openURL
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: ServersViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded, let servers = viewModel.servers {
                    ForEach(servers) { server in
                        Section {
                            ServerRowView(server: server)
                        }
                    }
                    
                    if servers.isEmpty {
                        Text("Keine Server")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                    }
                    
                } else {
                    HandlerView(status: viewModel.status)
                }
                
                Section {
                    NavigationLink {
                       InvoicesView()
                    } label: {
                        HStack {
                            Image(systemName: "list.bullet")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Rechnungen")
                        }
                    }
                }
            }
            .navigationTitle("Server")
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarLeading)
                
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        
                        Button {
                            openURL(URL(string: "https://app.virtbase.com/")!)
                        } label: {
                            HStack {
                                Image(systemName: "arrow.up.right")
                                Text("Dashboard")
                            }
                        }
                        
                        Button {
                            openURL(URL(string: "https://app.virtbase.com/account/settings")!)
                        } label: {
                            HStack {
                                Image(systemName: "person.fill")
                                Text("Account")
                            }
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            Task {
                                try authentication.deauthenticate()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "door.right.hand.open")
                                Text("Abmelden")
                            }
                        }
                    } label: {
                        Image(systemName: "person.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        openURL(URL(string: "https://virtbase.com/de")!)
                    } label: {
                        Image(systemName: "plus")
                            .padding(.horizontal, 5)
                    }
                }
            }
            .refreshable {
                Upstream.refresh()
            }
            .task {
                await viewModel.fetch(
                    session: authentication.session
                )
            }
            .onReceive(Upstream.refreshed) { _ in
                Task {
                    await viewModel.fetch(
                        session: authentication.session
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
