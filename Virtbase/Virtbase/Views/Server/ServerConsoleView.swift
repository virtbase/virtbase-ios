//
//  ServerConsoleView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 25.02.26.
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
import WebKit

struct ServerConsoleView: View {
    
    @EnvironmentObject private
    var authentication: AuthenticationModel
    
    @Environment(\.dismiss)
    private var dismiss
    
    var server: Server
    
    @State private
    var console: URL?
    
    var body: some View {
        NavigationStack {
            Group {
                if let console {
                    ConsoleWebView(url: console)
                } else {
                    ProgressView()
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            self.console = try await Server.console(
                                session: authentication.session,
                                server: server
                            )
                        }
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                    }
                }
                
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Beenden") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            Task {
                self.console = try await Server.console(
                    session: authentication.session,
                    server: server
                )
            }
        }
        .onDisappear {
            self.console = nil
        }
    }
}

private struct ConsoleWebView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
