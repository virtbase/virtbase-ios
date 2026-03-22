//
//  Backup.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 07.03.26.
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

nonisolated struct Backup: Identifiable, Decodable {
    var id: String
    var name: String
    var locked: Bool?
    var size: Int?
    
    var started: Date?
    var failed: Date?
    var finished: Date?
    var template: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case locked = "is_locked"
        case size = "size"
        case started = "started_at"
        case failed = "failed_at"
        case finished = "finished_at"
        case template = "template"
    }
}
