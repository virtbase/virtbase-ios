//
//  KeyPermissionsView.swift
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

struct KeyPermissionsView: View {
    
    @Environment(\.dismiss) private
    var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    
                    HStack(spacing: 10) {
                        Text("KVM")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Text("NameServer")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Text("Firewall")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Text("Backups")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Text("Konsole")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                    HStack(spacing: 10) {
                        Text("Rechnungen")
                            .monospaced()
                        
                        Spacer(minLength: 0)
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                            Text("Lesen")
                        }
                        .frame(minWidth: 80)
                        
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                            Text("Schreiben")
                        }
                        .frame(minWidth: 80)
                    }
                    
                } header: {
                    Text("Schlüssel")
                } footer: {
                    Text("Diese Berechtigungen sind notwendig, damit die Virtbase App ordnungsgemäß funktionieren kann. Das Entfernen oder Einschränken dieser Berechtigungen kann zu Fehlfunktionen der App führen und unauthentifizierte Anfragen verursachen.")
                }
                
            }
            .navigationTitle("Berechtigungen")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Zurück") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Fortfahren") {
                        KeyAuthenticationView()
                    }
                }
            }
        }
    }
}
