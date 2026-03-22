//
//  FirewallRuleCreationSheet.swift
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

struct FirewallRuleCreationSheet: View {
    
    var server: Server
    var session: Session
    @ObservedObject var viewModel: FirewallViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: FirewallRuleType = .ingoing
    @State private var action: FirewallOptions.Action = .accept
    @State private var proto: FirewallProtocol?
    @State private var sport: String = ""
    @State private var dport: String = ""
    @State private var comment: String = ""
    @State private var enabled: Bool = true
    @State private var icmpType: String = "any"
    
    var body: some View {
        NavigationStack {
            Form {
                FirewallRuleFormFields(
                    type: $type,
                    action: $action,
                    enabled: $enabled,
                    comment: $comment,
                    proto: $proto,
                    sport: $sport,
                    dport: $dport,
                    icmpType: $icmpType
                )
            }
            .navigationTitle("Neue Regel")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Erstellen") {
                        let request = FirewallRuleCreateRequest(
                            type: type,
                            action: action,
                            enable: enabled ? 1 : 0,
                            comment: comment,
                            proto: proto,
                            digest: nil,
                            sport: sport,
                            dport: dport,
                            icmpType: (proto == .icmp ? icmpType : nil)
                        )
                        
                        Task {
                            await viewModel.createRule(
                                session: session,
                                server: server,
                                request: request
                            )
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
