//
//  ServerState.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 17.02.26.
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

nonisolated struct ServerState: Decodable {
    var status: ServerStatus
    var statistics: ServerStatistics?
    var task: ServerTask?
    var installed: String?
    var suspended: String?
    var terminates: String?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case statistics = "stats"
        case task = "task"
        case installed = "installedAt"
        case suspended = "suspendedAt"
        case terminates = "terminatesAt"
    }
}
