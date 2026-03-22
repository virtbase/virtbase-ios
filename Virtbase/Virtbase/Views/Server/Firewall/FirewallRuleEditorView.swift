//
//  FirewallRuleEditorView.swift
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

struct FirewallRuleEditorView: View {
    
    var server: Server
    var rule: FirewallRule
    var session: Session
    @ObservedObject var viewModel: FirewallViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var type: FirewallRuleType
    @State private var action: FirewallOptions.Action
    @State private var proto: FirewallProtocol?
    @State private var sport: String
    @State private var dport: String
    @State private var comment: String
    @State private var enabled: Bool
    @State private var icmpType: String
    
    init(
        server: Server,
        rule: FirewallRule,
        session: Session,
        viewModel: FirewallViewModel
    ) {
        self.server = server
        self.rule = rule
        self.session = session
        self.viewModel = viewModel
        
        _type = State(initialValue: rule.type)
        _action = State(initialValue: rule.action)
        _proto = State(initialValue: rule.protocol)
        _sport = State(initialValue: rule.source ?? "")
        _dport = State(initialValue: rule.destination ?? "")
        _comment = State(initialValue: rule.description ?? "")
        _enabled = State(initialValue: (rule.enabled ?? 1) == 1)
        _icmpType = State(initialValue: rule.icmpType ?? "any")
    }
    
    var body: some View {
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
        .navigationTitle("Regel bearbeiten")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Speichern") {
                    let request = FirewallRuleUpdateRequest(
                        type: type,
                        action: action,
                        enable: enabled ? 1 : 0,
                        comment: comment,
                        proto: proto,
                        digest: rule.digest,
                        sport: sport,
                        dport: dport,
                        icmpType: (proto == .icmp ? icmpType : nil)
                    )
                    
                    Task {
                        await viewModel.updateRule(
                            session: session,
                            server: server,
                            pos: rule.position,
                            request: request
                        )
                        dismiss()
                    }
                }
            }
        }
    }
}
