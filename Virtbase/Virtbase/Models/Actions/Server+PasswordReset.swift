//
//  Server+PasswordReset.swift
//  Virtbase
//
//  Created by OpenAI on 02.05.26.
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
import Combine

nonisolated struct ServerPasswordResetRequest: Encodable {
    let username: String
    let password: String
}

extension Server {
    static func resetPassword(
        session: Session,
        server: Server,
        username: String = "root",
        password: String
    ) async throws {
        let address = (
            Configuration.BASE_URL
            + "/servers/actions/\(server.id)/reset-password"
        )

        let body = ServerPasswordResetRequest(
            username: username,
            password: password
        )

        let _ = try await session.request(
            address,
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}
