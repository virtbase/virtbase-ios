//
//  FirewallRuleRow.swift
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

struct FirewallRuleRow: View {
    
    var rule: FirewallRule
    
    var body: some View {
        HStack {
            if let enabled = rule.enabled, enabled == 1 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.subheadline)
                    .padding(.trailing, 5)
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(rule.source ?? "Alle")
                    
                    Image(systemName: "arrow.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .padding(.horizontal, 5)
                    
                    Text(rule.destination ?? "Alle")
                    
                    Spacer(minLength: 0)
                    
                    Text(rule.protocol?.rawValue ?? "Alle")
                        .monospaced()
                        .font(.subheadline)
                }
                
                HStack {
                    Text(rule.description ?? "Keine Beschreibung")
                    
                    Spacer(minLength: 0)
                    
                    switch rule.action {
                    case .accept:
                        Text("Akzeptieren")
                    case .drop:
                        Text("Ignorieren")
                    case .reject:
                        Text("Ablehnen")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
    }
}
