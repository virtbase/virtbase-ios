//
//  FirewallRule+Move.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 18.03.26.
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

nonisolated struct FirewallRuleMoveRequest: Encodable {
    let moveto: Int
    let digest: String?
}

extension FirewallRule {
    static func move(
        session: Session,
        server: Server,
        pos: Int,
        moveto: Int,
        digest: String?
    ) async throws {
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/firewall/rules/\(pos)/move"
        )
        
        let body = FirewallRuleMoveRequest(
            moveto: moveto,
            digest: digest
        )
        
        let _ = try await session.request(
            address,
            method: .put,
            parameters: body,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}

