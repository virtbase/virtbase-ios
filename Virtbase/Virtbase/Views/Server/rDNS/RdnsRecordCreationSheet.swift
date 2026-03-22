//
//  RdnsRecordCreationSheet.swift
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

struct RdnsRecordCreationSheet: View {
    
    var server: Server
    @ObservedObject var viewModel: ServerRdnsViewModel
    var session: Session
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var ip: String = ""
    @State private var hostname: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                RdnsRecordFormFields(hostname: $hostname, ip: $ip)
            }
            .navigationTitle("Neuer Eintrag")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
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
                    .disabled(ip.isEmpty || hostname.isEmpty)
                }
            }
        }
    }
}
