//
//  FirewallOptions.swift
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
struct FirewallOptions: Codable {
    
    nonisolated
    enum Action: String, Codable {
        case accept = "ACCEPT"
        case drop = "DROP"
        case reject = "REJECT"
    }
    
    var ingoing: Action
    var outgoing: Action
    
    enum CodingKeys: String, CodingKey {
        case ingoing = "policy_in"
        case outgoing = "policy_out"
    }
}
