//
//  Options+Update.swift
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

import Foundation
import Alamofire

extension FirewallOptions {
    static func update(
        session: Session,
        server: Server,
        options: FirewallOptions
    ) async throws {
        let address = (
            Configuration.BASE_URL
            + "/servers/\(server.id)/firewall/options"
        )
        
        let _ = try await session.request(
            address,
            method: .put,
            parameters: options,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        // We need this, otherwise Alamofire bitches around
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}
