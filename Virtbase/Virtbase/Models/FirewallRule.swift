//
//  FirewallRule.swift
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

nonisolated
enum FirewallRuleType: String, Codable, CaseIterable, Hashable {
    case ingoing = "in"
    case outgoing = "out"
}

nonisolated
enum FirewallProtocol: String, Codable, CaseIterable, Hashable {
    case all = "*"
    case tcp
    case udp
    case icmp
    case igmp
    case ggp
    case ipencap
    case st
    case egp
    case igp
    case pup
    case hmp
    case xns_idp = "xns-idp"
    case rdp
    case iso_tp4 = "iso-tp4"
    case dccp
    case xtp
    case ddp
    case idpr_cmtp = "idpr-cmtp"
    case ipv6
    case ipv6_route = "ipv6-route"
    case ipv6_frag = "ipv6-frag"
    case idrp
    case rsvp
    case gre
    case esp
    case ah
    case skip
    case ipv6_icmp = "ipv6-icmp"
    case ipv6_nonxt = "ipv6-nonxt"
    case ipv6_opts = "ipv6-opts"
    case vmtp
    case eigrp
    case ospf
    case ax25 = "ax.25"
    case ipip
    case etherip
    case encap
    case pim
    case ipcomp
    case vrrp
    case l2tp
    case isis
    case sctp
    case fc
    case mobility_header = "mobility-header"
    case udplite
    case mpls_in_ip = "mpls-in-ip"
    case hip
    case shim6
    case wesp
    case rohc
}

nonisolated
struct FirewallRule: Codable {
    
    var position: Int
    var description: String?
    
    var `protocol`: FirewallProtocol?
    var action: FirewallOptions.Action
    var type: FirewallRuleType
    
    var enabled: Bool?
    var digest: String?
    var icmpType: String?
    
    var source: String?
    var destination: String?
    
    enum CodingKeys: String, CodingKey {
        case position = "pos"
        case description = "comment"
        case `protocol` = "proto"
        case action = "action"
        case type = "direction"
        case enabled = "enabled"
        case digest = "digest"
        case icmpType = "icmp_type"
        case source = "sport"
        case destination = "dport"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        position = try container.decode(Int.self, forKey: .position)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        action = try container.decode(FirewallOptions.Action.self, forKey: .action)
        type = try container.decodeIfPresent(FirewallRuleType.self, forKey: .type) ?? .ingoing
        enabled = try container.decodeIfPresent(Bool.self, forKey: .enabled)
        digest = try container.decodeIfPresent(String.self, forKey: .digest)
        icmpType = try container.decodeIfPresent(String.self, forKey: .icmpType)
        source = try container.decodeIfPresent(String.self, forKey: .source)
        destination = try container.decodeIfPresent(String.self, forKey: .destination)
        
        if let rawProtocol = try container.decodeIfPresent(String.self, forKey: .protocol) {
            `protocol` = FirewallProtocol(rawValue: rawProtocol)
        } else {
            `protocol` = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(`protocol`, forKey: .protocol)
        try container.encode(action, forKey: .action)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(enabled, forKey: .enabled)
        try container.encodeIfPresent(digest, forKey: .digest)
        try container.encodeIfPresent(icmpType, forKey: .icmpType)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(destination, forKey: .destination)
    }
}

extension FirewallRule: Identifiable {
    var id: Int { position }
}

nonisolated
struct FirewallRulesResponse: Decodable {
    var rules: [FirewallRule]
}
