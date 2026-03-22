//
//  ServerInformation.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 14.03.26.
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
struct ServerNode: Codable {
    var name: String
    var storage: String
    var memory: String
    var processor: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case storage = "storageDescription"
        case memory = "memoryDescription"
        case processor = "cpuDescription"
    }
}

nonisolated
struct ServerDatacenter: Codable {
    var name: String
    var country: String
}

nonisolated
struct ServerAllocation: Identifiable, Codable {
    var id: String
    var subnet: Subnet
    
    nonisolated
    struct Subnet: Codable {
        var id: String
        var address: String
        var gateway: String
        var family: Int
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case address = "cidr"
            case gateway = "gateway"
            case family = "family"
        }
    }
}

nonisolated
struct ServerInformation: Codable {
    var node: ServerNode
    var datacenter: ServerDatacenter
    var allocations: [ServerAllocation]
}
