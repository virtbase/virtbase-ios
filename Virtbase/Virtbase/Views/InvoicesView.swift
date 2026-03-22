//
//  ServerInvoiceView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 14.03.26.
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

struct InvoicesView: View {
    
    @Environment(\.openURL) private
    var openURL
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @StateObject private
    var viewModel: InvoicesViewModel = .init()
    
    var body: some View {
        NavigationStack {
            List {
                if viewModel.status == .succeeded, let invoices = viewModel.invoices {
                    ForEach(invoices) { invoice in
                        NavigationLink {
                            InvoiceDetailView(invoice: invoice)
                        } label: {
                            HStack {
                                Text(invoice.number)
                                    .monospaced()
                                    .fontWeight(.light)
                                
                                Spacer(minLength: 0)
                                
                                if let price = invoice.total {
                                    Text("\(price / 100, specifier: "%.2f") €")
                                        .foregroundStyle(.secondary)
                                        .font(.subheadline)
                                }
                                
                            }
                        }
                    }
                } else {
                    HandlerView(status: viewModel.status)
                }
            }
            .navigationTitle("Rechnungen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        openURL(URL(string: "https://app.virtbase.com/invoices")!)
                    } label: {
                        HStack {
                            Image(systemName: "network")
                                .font(.subheadline)
                            Text("Browser Öffnen")
                        }
                    }
                }
            }
        }
        .refreshable {
            Upstream.refresh()
        }
        .task {
            await viewModel.fetch(
                session: authentication.session
            )
        }
        .onReceive(Upstream.refreshed) { _ in
            Task {
                await viewModel.fetch(
                    session: authentication.session
                )
            }
        }
    }
}
