//
//  ServerGraph.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 18.02.26.
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

nonisolated struct ServerGraph: Decodable {
    var processor: Double
    var memory: Double
    var maximumMemory: Double
    var diskRead: Double
    var diskWrite: Double
    var networkIncoming: Double
    var networkOutgoing: Double
    var time: Date
    
    enum CodingKeys: String, CodingKey {
        case processor = "cpu"
        case memory = "mem"
        case maximumMemory = "maxmem"
        case diskRead = "diskread"
        case diskWrite = "diskwrite"
        case networkIncoming = "netin"
        case networkOutgoing = "netout"
        case time = "time"
    }
}
