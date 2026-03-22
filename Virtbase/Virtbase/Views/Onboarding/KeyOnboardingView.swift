//
//  AuthenticationOptionsView.swift
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

struct KeyOnboardingView: View {
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(spacing: 5) {
                        Image(systemName: "key.shield.fill")
                            .foregroundStyle(.accent)
                            .font(.system(size: 45))
                            .padding(5)
                        
                        Text("Virtbase Schlüssel")
                            .font(.headline)
                        
                        Text("Virtbase verwendet sogenannte API-Schlüssel, um Entwicklern eine einfache und zuverlässige Schnittstelle für Erweiterungen, Integrationen und automatisierte Systeme bereitzustellen. Die Virtbase App greift auf diese Schlüssel zu, um entsprechende Funktionen zu ermöglichen.")
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                    .multilineTextAlignment(.center)
                    .padding(10)
                }
                
                Section("Mehr Optionen") {
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 25)
                            Text("Mail & Passwort")
                            
                            Text("Bald Verfügbar")
                                .font(.caption2)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 5)
                                .background {
                                    Capsule()
                                        .foregroundStyle(.accent)
                                }
                        }
                    } .disabled(true)
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 25)
                            Text("Virtbase OAuth")
                            
                            Text("Bald Verfügbar")
                                .font(.caption2)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 5)
                                .background {
                                    Capsule()
                                        .foregroundStyle(.accent)
                                }
                        }
                    } .disabled(true)
                }
            }
            .navigationTitle("Anmelden")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    
                    // does absolutely nothing
                    // used for interface continuity
                    Button("Zurück") {}
                        .disabled(true)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Fortfahren") {
                        KeyPermissionsView()
                    }
                }
            }
        }
    }
}
