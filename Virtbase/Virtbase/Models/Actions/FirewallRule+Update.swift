//
//  FirewallRule+Update.swift
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

nonisolated struct FirewallRuleUpdateRequest: Encodable {
    let direction: FirewallRuleType
    let pos: Int
    let action: FirewallOptions.Action
    let enabled: Bool
    let comment: String?
    let proto: FirewallProtocol
    let digest: String?
    let sport: String?
    let dport: String?
    let icmpType: String?
    
    enum CodingKeys: String, CodingKey {
        case direction
        case pos
        case action
        case enabled
        case comment
        case proto
        case digest
        case sport
        case dport
        case icmpType = "icmp_type"
    }
    
    init(
        direction: FirewallRuleType,
        pos: Int,
        action: FirewallOptions.Action,
        enabled: Bool,
        comment: String,
        proto: FirewallProtocol,
        digest: String?,
        sport: String,
        dport: String,
        icmpType: String?
    ) {
        let sport = FirewallRuleRequestSanitizer.optional(sport)
        let dport = FirewallRuleRequestSanitizer.optional(dport)
        
        self.direction = direction
        self.pos = pos
        self.action = action
        self.enabled = enabled
        self.comment = FirewallRuleRequestSanitizer.optional(comment)
        self.proto = FirewallRuleRequestSanitizer.required(proto)
        self.digest = FirewallRuleRequestSanitizer.optional(digest)
        self.sport = sport
        self.dport = dport
        self.icmpType = FirewallRuleRequestSanitizer.optional(icmpType)
    }
}

extension FirewallRule {
    static func update(
        session: Session,
        server: Server,
        pos: Int,
        request: FirewallRuleUpdateRequest
    ) async throws {
        let address = (
            Configuration.BASE_URL
            + "/servers/\(server.id)/firewall/rules"
        )
        
        let _ = try await session.request(
            address,
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}
