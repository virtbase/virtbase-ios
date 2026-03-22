//
//  FirewallRule+Delete.swift
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

extension FirewallRule {
    static func delete(
        session: Session,
        server: Server,
        pos: Int,
        digest: String?
    ) async throws {
        var components = URLComponents(string: (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/firewall/rules/\(pos)"
        ))
        
        if let digest, !digest.isEmpty {
            components?.queryItems = [
                URLQueryItem(name: "digest", value: digest)
            ]
        }
        
        guard let address = components?.url?.absoluteString else {
            throw URLError(.badURL)
        }
        
        let _ = try await session.request(
            address,
            method: .delete
        )
        .validate()
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}

