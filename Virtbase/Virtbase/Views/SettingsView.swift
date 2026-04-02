//
//  SettingsView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 20.02.26.
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
import StoreKit

struct SettingsView: View {
    
    @Environment(\.openURL) private
    var openURL
    
    @Environment(\.requestReview)
    var requestReview
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @State private
    var displayDeletion: Bool = false
    
    @State private
    var displayDeletionError: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Virtbase") {
                    Button {
                        openURL(URL(string: "https://virtbase.com/de")!)
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Website")
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        .contentShape(Rectangle())
                    } .buttonStyle(.plain)
                    
                    Button {
                        openURL(URL(string: "mailto:support@virtbase.com")!)
                    } label: {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("E-Mail")
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        .contentShape(Rectangle())
                    } .buttonStyle(.plain)
                    
                    Button {
                        openURL(URL(string: "https://discord.gg/ywrqTubzh5")!)
                    } label: {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Discord")
                            
                            Spacer(minLength: 0)
                            
                            Image(systemName: "arrow.up.right")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                        .contentShape(Rectangle())
                    } .buttonStyle(.plain)
                }
                
                Button {
                    requestReview()
                } label: {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.tint)
                            .frame(minWidth: 30)
                        
                        Text("Bewerten")
                    }
                    .contentShape(Rectangle())
                } .buttonStyle(.plain)
                
                Section("Anwendung") {
                    NavigationLink {
                        LicenceView()
                    } label: {
                        HStack {
                            Image(systemName: "signature")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Beinhaltete Lizenzen")
                        }
                    }
                    
                    Button {
                        displayDeletion.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .frame(minWidth: 30)
                            
                            Text("Alle Daten Löschen")
                        } .foregroundStyle(.red)
                    }
                    .alert("Alle Anwendungsdaten löschen?", isPresented: $displayDeletion) {
                        Button("Abbrechen", role: .cancel) {}
                        Button("Löschen", role: .destructive) {
                            do {
                                try authentication.deauthenticate()
                            } catch {
                                displayDeletionError = true
                            }
                        }
                    } message: {
                        Text("Alle lokalen Daten werden entfernt, und sie werden sofort abgemeldet. Dies lässt sich nicht rückgangig machen.")
                    }
                    .alert("Löschen fehlgeschlagen", isPresented: $displayDeletionError) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Die Keychain konnte nicht geleert werden. Bitte erneut versuchen oder die App neu installieren.")
                    }
                }
            }
            .navigationTitle("Einstellungen")
        }
    }
}

#Preview {
    SettingsView()
}
