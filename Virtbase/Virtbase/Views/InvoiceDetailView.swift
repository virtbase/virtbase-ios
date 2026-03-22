//
//  InvoiceDetailView.swift
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

struct InvoiceDetailView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    var invoice: Invoices.Invoice
    
    @State private
    var downloaded: URL?
    
    var body: some View {
        NavigationStack {
            List {
                
                Section("Preise") {
                    HStack {
                        
                        if let total = invoice.total {
                            VStack {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("\(total / 100, specifier: "%.2f")")
                                        .font(.headline)
                                    Text("€")
                                        .font(.subheadline)
                                }
                                
                                Text("Total")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if let tax = invoice.tax {
                            VStack {
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                    Text("\(tax / 100, specifier: "%.2f")")
                                        .font(.headline)
                                    Text("€")
                                        .font(.subheadline)
                                }
                                
                                Text("Steuer")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                
                            } .frame(maxWidth: .infinity)
                        }
                    } .padding(5)
                }
                
                Section("Daten") {
                    if let date = invoice.created {
                        HStack {
                            Text("Erstellt")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(date.formatted(date: .abbreviated, time: .standard))
                        }
                    }
                    
                    if let date = invoice.updated {
                        HStack {
                            Text("Aktualisiert")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(date.formatted(date: .abbreviated, time: .standard))
                        }
                    }
                    
                    if let date = invoice.sent {
                        HStack {
                            Text("Gesendet")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(date.formatted(date: .abbreviated, time: .standard))
                        }
                    }
                    
                    if let date = invoice.cancelled {
                        HStack {
                            Text("Abgebrochen")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(date.formatted(date: .abbreviated, time: .standard))
                        }
                    }
                    
                    if let date = invoice.paid {
                        HStack {
                            Text("Bezahlt")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            Spacer(minLength: 0)
                            Text(date.formatted(date: .abbreviated, time: .standard))
                        }
                    }
                }
                
                if let downloaded {
                    ShareLink(item: downloaded)
                } else {
                    Button {
                        Task {
                            self.downloaded = try await Invoices.download(
                                session: authentication.session,
                                invoice: invoice
                            )
                        }
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                                .foregroundStyle(.tint)
                                .frame(minWidth: 30)
                            
                            Text("Herunterladen")
                        }
                    }
                }
            }
            .navigationTitle(invoice.number)
        }
    }
}
