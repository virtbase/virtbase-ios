//
//  FirewallRuleFormFields.swift
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

/// Gemeinsames Formular für Erstellung und Bearbeitung von Firewall-Regeln.
struct FirewallRuleFormFields: View {
    
    @Binding var type: FirewallRuleType
    @Binding var action: FirewallOptions.Action
    @Binding var enabled: Bool
    @Binding var comment: String
    @Binding var proto: FirewallProtocol?
    @Binding var sport: String
    @Binding var dport: String
    @Binding var icmpType: String
    
    var body: some View {
        Section {
            Picker("Richtung", selection: $type) {
                Text("Eingehend").tag(FirewallRuleType.ingoing)
                Text("Ausgehend").tag(FirewallRuleType.outgoing)
            }
            
            Picker("Aktion", selection: $action) {
                Text("Akzeptieren").tag(FirewallOptions.Action.accept)
                Text("Ignorieren").tag(FirewallOptions.Action.drop)
                Text("Ablehnen").tag(FirewallOptions.Action.reject)
            }
            
            Toggle("Aktiv", isOn: $enabled)
            
            TextField("Kommentar", text: $comment)
        } header: {
            Text("Allgemein")
        }
        
        Section {
            Picker("Protokoll", selection: $proto) {
                Text("Alle").tag(FirewallProtocol?.none)
                ForEach(FirewallProtocolPickerSupport.selectableProtocols, id: \.self) { p in
                    Text(FirewallProtocolPickerSupport.label(for: p))
                        .tag(FirewallProtocol?.some(p))
                }
            }
            
            TextField("Quellport", text: $sport)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            TextField("Zielport", text: $dport)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if proto == .icmp {
                TextField("ICMP-Typ", text: $icmpType)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        } header: {
            Text("Regel")
        }
    }
}
