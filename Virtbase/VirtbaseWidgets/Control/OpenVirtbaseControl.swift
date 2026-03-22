//
//  OpenVirtbaseControl.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 03.03.26.
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
import WidgetKit
import AppIntents

struct OpenAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Virtbase öffnen"
    static var openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct OpenVirtbaseControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "com.virtbase.openApp"
        ) {
            ControlWidgetButton(action: OpenAppIntent()) {
                Label("Virtbase", image: "virtbase")
            }
        }
        .displayName("Virtbase öffnen")
        .description("Öffnet die Virtbase App.")
    }
}
