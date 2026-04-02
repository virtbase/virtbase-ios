//
//  HandlerView.swift
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

struct HandlerView: View {
    
    var status: RequestStatus
    
    var body: some View {
        Group {
            switch status {
            case .processing, .unknown:
                Image(systemName: "progress.indicator")
                    .symbolRenderingMode(.hierarchical)
                    .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                    .foregroundStyle(.secondary)
            case .succeeded:
                // Screens that use this view branch on .succeeded before showing content; this arm covers edge cases without a misleading spinner.
                EmptyView()
            case .failed:
                VStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.tertiary)
                        .font(.largeTitle)
                        .padding(5)
                    
                    Text("Anfragefehler")
                        .font(.headline)
                    
                    Text("Die Anfrage an den Server ist fehlgeschlagen. Überprüfe ob du mit dem Internet verbunden bist oder dein Schlüssel alle benötigten Berechtigungen hat.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
    }
}

#Preview {
    HandlerView(status: .failed)
}
