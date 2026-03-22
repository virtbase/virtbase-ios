//
//  RebootServerControl.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 01.03.26.
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

struct RebootServerControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: "com.virtbase.rebootServer",
            intent: SelectServerIntent.self
        ) { config in
            ControlWidgetButton(
                action: ServerActionIntent(
                    server: config.server,
                    action: .reboot
                )
            ) {
                if let server = config.server {
                    Label(
                        "\(server.name) Neustarten",
                        image: "custom.reboot.virtbase"
                    )
                } else {
                    Label(
                        "Server Auswählen",
                        image: "custom.reboot.virtbase"
                    )
                }
            } .disabled(config.server == nil)
        }
        .displayName("Server neustarten")
        .description("Startet den ausgewählten Server neu.")
    }
}
