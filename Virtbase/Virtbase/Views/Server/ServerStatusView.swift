//
//  ServerStatusView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 18.02.26.
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

struct ServerStatusView: View {
    
    var status: ServerStatus
    
    var body: some View {
        switch status {
        case .running:
            Image(systemName: "play.fill")
                .foregroundStyle(.green)
                .font(.caption)
            
            Text("Online")
        case .stopped:
            Image(systemName: "stop.fill")
                .foregroundStyle(.red)
                .font(.caption)
            
            Text("Offline")
        case .paused:
            Image(systemName: "pause.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            
            Text("Pausiert")
        case .suspended:
            Image(systemName: "moon.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            
            Text("Suspendiert")
        case .unknown:
            Image(systemName: "questionmark.circle.fill")
                .foregroundStyle(.tertiary)
                .font(.caption)
            
            Text("Unbekannt")
        }
    }
}
