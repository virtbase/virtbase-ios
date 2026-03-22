//
//  ServerBackupsView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 07.03.26.
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

struct ServerBackupsView: View {
    
    @EnvironmentObject private var authentication: AuthenticationModel
    
    @StateObject private var viewModel: BackupsViewModel = .init()
    
    @State private var displayCreation = false
    
    var server: Server
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded, let backups = viewModel.backups {
                    ForEach(backups) { backup in
                        BackupListRow(
                            backup: backup,
                            server: server,
                            viewModel: viewModel
                        )
                    }
                } else {
                    HandlerView(status: viewModel.status)
                }
            }
            .navigationTitle("Backups")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Erstellen") {
                        displayCreation = true
                    }
                }
            }
        }
        .sheet(isPresented: $displayCreation) {
            BackupCreationSheet(
                server: server,
                viewModel: viewModel
            )
            .environmentObject(authentication)
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
