//
//  ServerTaskView.swift
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

struct ServerTaskView: View {
    
    var task: ServerTask
    
    var body: some View {
        switch task {
        case .rebooting:
            Text("Neustart läuft")
        case .stopping:
            Text("Wird gestoppt")
        case .shutting:
            Text("Wird heruntergefahren")
        case .resuming:
            Text("Wird fortgesetzt")
        case .pausing:
            Text("Wird pausiert")
        case .suspending:
            Text("Wird ausgesetzt")
        case .backing:
            Text("Backup wird erstellt")
        case .restoring:
            Text("Wird wiederhergestellt")
        case .starting:
            Text("Wird gestartet")
        case .resetting:
            Text("Wird zurückgesetzt")
        case .unknown:
            Text("Unbekannt")
        }
    }
}
