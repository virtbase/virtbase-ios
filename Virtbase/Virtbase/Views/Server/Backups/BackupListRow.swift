//
//  BackupListRow.swift
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

struct BackupListRow: View {
    
    var backup: Backup
    var server: Server
    @ObservedObject var viewModel: BackupsViewModel
    
    @EnvironmentObject private var authentication: AuthenticationModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(backup.name)
                    
                    if let locked = backup.locked, locked {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                
                if let finished = backup.finished {
                    Text(finished.formatted())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    HStack {
                        Text("Bearbeitung")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        ProgressView()
                            .controlSize(.small)
                    }
                }
            }
            .lineLimit(1)
            
            Spacer(minLength: 0)
            
            if let size = backup.size {
                Text(ByteCountFormatter.string(fromByteCount: Int64(size), countStyle: .file))
                    .font(.subheadline)
                    .monospaced()
            }
        }
        .contextMenu {
            Button {
                Task {
                    try await Backup.restore(
                        session: authentication.session,
                        server: server,
                        backup: backup
                    )
                }
            } label: {
                Label("Wiederherstellen", systemImage: "square.and.arrow.down")
            }
            
            Divider()
            
            if let locked = backup.locked {
                Button {
                    Task {
                        try await Backup.toggle(
                            session: authentication.session,
                            server: server,
                            backup: backup
                        )
                        
                        try await Task.sleep(nanoseconds: UInt64(1e+9))
                        
                        await viewModel.fetch(
                            session: authentication.session,
                            server: server
                        )
                    }
                } label: {
                    if locked {
                        Label("Entsperren", systemImage: "lock.open")
                    } else {
                        Label("Sperren", systemImage: "lock")
                    }
                }
            } else {
                Label("Sperren", systemImage: "lock")
            }
            
            if let locked = backup.locked {
                Button(role: .destructive) {
                    Task {
                        try await Backup.delete(
                            session: authentication.session,
                            server: server,
                            backup: backup
                        )
                    }
                } label: {
                    Label("Löschen", systemImage: "trash")
                }
                .disabled(locked)
            } else {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}
