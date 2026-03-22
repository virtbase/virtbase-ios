//
//  FirewallRule+Create.swift
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

nonisolated struct FirewallRuleCreateRequest: Encodable {
    let type: FirewallRuleType
    let action: FirewallOptions.Action
    let enable: Int
    let comment: String
    let proto: FirewallProtocol?
    let digest: String?
    let sport: String
    let dport: String
    let icmpType: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case action
        case enable
        case comment
        case proto
        case digest
        case sport
        case dport
        case icmpType = "icmp-type"
    }
}

extension FirewallRule {
    static func create(
        session: Session,
        server: Server,
        request: FirewallRuleCreateRequest
    ) async throws {
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/firewall/rules"
        )
        
        let _ = try await session.request(
            address,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}

