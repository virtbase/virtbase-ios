//
//  ServerActionIntent.swift
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
import Alamofire
import AppIntents

struct ServerActionIntent: AppIntent {
    
    static let title: LocalizedStringResource = "Aktion auf Server ausführen"
    static var isDiscoverable = true

    @Parameter(title: "Server")
    var server: ServerEntity?
    
    @Parameter(title: "Action")
    var action: ServerStateUpdate?

    init(server: ServerEntity?, action: ServerStateUpdate?) {
        self.server = server
        self.action = action
    }
    
    init() {}

    func perform() async throws -> some IntentResult {
        guard let server, let action else { return .result() }

        let session = Session(
            configuration: .ephemeral,
            interceptor: InterceptorModel()
        )

        try await ServerState.update(
            session: session,
            server: server.server,
            status: action
        )
    
        return .result()
    }
}
