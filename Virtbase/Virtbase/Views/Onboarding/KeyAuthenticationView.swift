//
//  KeyAuthenticationView.swift
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

struct KeyAuthenticationView: View {
    
    @Environment(\.dismiss) private
    var dismiss
    
    @Environment(\.openURL)
    private var openURL
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @State private
    var displayToken: String = ""
    
    @State private
    var displayFailed: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Schlüssel") {
                    if authentication.state == .deauthenticated {
                        SecureField("sk_live_…", text: $displayToken)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.return)
                            .monospaced()
                    } else if authentication.state == .processing {
                        HStack {
                            Text("Bearbeitung")
                            Spacer(minLength: 0)
                            ProgressView()
                        }
                    }
                    
                    if displayFailed {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.red)
                            Text("Fehlgeschlagen")
                        }
                    }
                }
                .onChange(of: authentication.state) { previous, current in
                    if previous == AuthenticationState.processing,
                       current == AuthenticationState.deauthenticated
                    {
                        self.displayToken = ""
                        self.displayFailed = true
                    } else if current == AuthenticationState.processing {
                        self.displayFailed = false
                    }
                }
                
                Section("Optionen") {
                    Button {
                        Task {
                            guard let token = UIPasteboard.general.string else { return }
                            try await authentication.authenticate(token: token)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "document.on.clipboard.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 25)
                            
                            Text("Einfügen")
                        }
                        .contentShape(Rectangle())
                    } .buttonStyle(.plain)
                    
                    Button {
                        let url = URL(string: "https://app.virtbase.com/account/settings/api")!
                        openURL(url)
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 25)
                            
                            Text("Erstellen")
                        }
                        .contentShape(Rectangle())
                    } .buttonStyle(.plain)
                }
            }
            .navigationTitle("Verifizieren")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Zurück") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fortfahren") {
                        Task {
                            guard !displayToken.isEmpty else { return }
                            try await authentication.authenticate(token: displayToken)
                        }
                    }
                    .disabled(authentication.state == .processing || displayToken.isEmpty)
                }
            }
        }
    }
}
