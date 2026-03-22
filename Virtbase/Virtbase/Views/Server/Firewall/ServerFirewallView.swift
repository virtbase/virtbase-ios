//
//  ServerFirewallView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 15.03.26.
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

struct ServerFirewallView: View {
    
    @EnvironmentObject private var authentication: AuthenticationModel
    
    @StateObject private var viewModel: FirewallViewModel = .init()
    
    var server: Server
    
    @State private var displayRuleCreation = false
    
    private func update(_ options: FirewallOptions) {
        viewModel.status = .processing
        
        Task {
            try await FirewallOptions.update(
                session: authentication.session,
                server: server,
                options: options
            )
            
            await viewModel.fetch(
                session: authentication.session,
                server: server
            )
        }
    }
    
    private func binding(
        get: @escaping () -> FirewallOptions.Action,
        set: @escaping (FirewallOptions.Action) -> FirewallOptions
    ) -> Binding<FirewallOptions.Action> {
        .init(
            get: get,
            set: { value in
                update(set(value))
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded,
                   let options = viewModel.options,
                   let rules = viewModel.rules {
                    
                    FirewallOptionsSection(
                        ingoing: binding(
                            get: { options.ingoing },
                            set: { FirewallOptions(ingoing: $0, outgoing: options.outgoing) }
                        ),
                        outgoing: binding(
                            get: { options.outgoing },
                            set: { FirewallOptions(ingoing: options.ingoing, outgoing: $0) }
                        )
                    )
                    
                    Section("Regeln") {
                        ForEach(rules, id: \.position) { rule in
                            NavigationLink {
                                FirewallRuleEditorView(
                                    server: server,
                                    rule: rule,
                                    session: authentication.session,
                                    viewModel: viewModel
                                )
                            } label: {
                                FirewallRuleRow(rule: rule)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteRule(
                                            session: authentication.session,
                                            server: server,
                                            rule: rule
                                        )
                                    }
                                } label: {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            guard let rulesSnapshot = viewModel.rules else { return }
                            for i in indexSet {
                                let rule = rulesSnapshot[i]
                                Task {
                                    await viewModel.deleteRule(
                                        session: authentication.session,
                                        server: server,
                                        rule: rule
                                    )
                                }
                            }
                        }
                        .onMove { source, destination in
                            guard let from = source.first,
                                  let rule = viewModel.rules?[from] else { return }
                            
                            let moveto = destination > from ? destination - 1 : destination
                            
                            Task {
                                await viewModel.moveRule(
                                    session: authentication.session,
                                    server: server,
                                    rule: rule,
                                    moveto: moveto
                                )
                            }
                        }
                    }
                    
                } else {
                    HandlerView(status: viewModel.status)
                }
            }
            .navigationTitle("Firewall")
            .toolbar {
                EditButton()
                
                Button {
                    displayRuleCreation = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .refreshable {
            Upstream.refresh()
        }
        .task {
            await viewModel.fetch(
                session: authentication.session,
                server: server
            )
        }
        .onReceive(Upstream.refreshed) { _ in
            Task {
                await viewModel.fetch(
                    session: authentication.session,
                    server: server
                )
            }
        }
        .sheet(isPresented: $displayRuleCreation) {
            FirewallRuleCreationSheet(
                server: server,
                session: authentication.session,
                viewModel: viewModel
            )
        }
    }
}
