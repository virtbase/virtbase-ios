//
//  Server+Rename.swift
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

import Foundation
import Alamofire
import Combine

// We will not create a custom Request encodable here
// for one single parameter, this is not required
// Custom Encodables are useful for multitype requests

extension Server {
    static func rename(
        session: Session,
        server: Server,
        name: String
    ) async throws {
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/rename"
        )
        
        let _ = try await session.request(
            address,
            method: .post,
            parameters: ["name": name],
            encoder: JSONParameterEncoder.default,
        )
        .validate()
        .serializingString()
        .value
    }
}
