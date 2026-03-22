//
//  VirtbaseApp.swift
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

@main
struct VirtbaseApp: App {
    
    @StateObject private
    var authenticationModel: AuthenticationModel
    = AuthenticationModel()
    
    @State private var refreshUpstream = 0
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch authenticationModel.state {
                case .authenticated:
                    ContentView()
                case .processing, .deauthenticated:
                    KeyOnboardingView()
                case .unknown:
                    ProgressView()
                }
            }
            .environmentObject(authenticationModel)
            .task {
                await authenticationModel.refresh()
            }
        }
    }
}
