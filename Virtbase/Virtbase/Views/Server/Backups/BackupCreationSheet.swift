//
//  BackupCreationSheet.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 20.03.26.
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

struct BackupCreationSheet: View {
    
    var server: Server
    @ObservedObject var viewModel: BackupsViewModel
    
    @EnvironmentObject private var authentication: AuthenticationModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var backupName: String = ""
    @State private var backupMode: BackupCreationMode = .snapshot
    
    var body: some View {
        NavigationStack {
            List {
                Section("Name") {
                    TextField("Backup", text: $backupName)
                }
                
                Section("Aktion") {
                    Picker("Aktion", selection: $backupMode) {
                        Text("Snapshot").tag(BackupCreationMode.snapshot)
                        Text("Suspendieren").tag(BackupCreationMode.suspend)
                        Text("Stoppen").tag(BackupCreationMode.stop)
                    }
                    .pickerStyle(.inline)
                    .labelsHidden()
                }
            }
            .navigationTitle("Neues Backup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        Task {
                            try await Backup.create(
                                session: authentication.session,
                                server: server,
                                name: backupName,
                                locked: false,
                                mode: backupMode
                            )
                            await viewModel.fetch(
                                session: authentication.session,
                                server: server
                            )
                            dismiss()
                        }
                    }
                    .disabled(backupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                backupName = "Backup \(Date.now.formatted())"
            }
        }
    }
}
