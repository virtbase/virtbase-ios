//
//  RdnsRecordEditorView.swift
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
import Alamofire

struct RdnsRecordEditorView: View {
    
    var server: Server
    var record: RdnsRecord
    @ObservedObject var viewModel: ServerRdnsViewModel
    var session: Session
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ip: String
    @State private var hostname: String
    
    init(
        server: Server,
        record: RdnsRecord,
        viewModel: ServerRdnsViewModel,
        session: Session
    ) {
        self.server = server
        self.record = record
        self.viewModel = viewModel
        self.session = session
        
        _ip = State(initialValue: record.ip)
        _hostname = State(initialValue: record.hostname)
    }
    
    var body: some View {
        Form {
            RdnsRecordFormFields(hostname: $hostname, ip: $ip)
        }
        .navigationTitle("Bearbeiten")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteRecord(
                            session: session,
                            server: server,
                            record: record
                        )
                        dismiss()
                    }
                } label: {
                    Label("Löschen", systemImage: "trash")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button("Speichern") {
                    Task {
                        await viewModel.upsertRecord(
                            session: session,
                            server: server,
                            ip: ip,
                            hostname: hostname
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}
