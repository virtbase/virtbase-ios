//
//  RdnsRecord.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 19.03.26.
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

nonisolated struct RdnsRecord: Identifiable, Codable, Hashable {
    var id: String
    var allocation: String
    var ip: String
    var hostname: String
    
    // API uses snake_case timestamps; we keep them as strings because
    // the UI does not rely on their type.
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case allocation
        case ip
        case hostname
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

nonisolated struct RdnsRecordsListResponse: Codable {
    var ptrRecords: [RdnsRecord]
    var meta: RdnsRecordsMeta?
    
    enum CodingKeys: String, CodingKey {
        case ptrRecords = "ptr_records"
        case meta
    }
}

nonisolated struct RdnsRecordsMeta: Codable {
    var pagination: RdnsPagination?
    
    enum CodingKeys: String, CodingKey {
        case pagination
    }
}

nonisolated struct RdnsPagination: Codable {
    var page: Int?
    var perPage: Int?
    var previousPage: Int?
    var nextPage: Int?
    var lastPage: Int?
    var totalEntries: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case previousPage = "previous_page"
        case nextPage = "next_page"
        case lastPage = "last_page"
        case totalEntries = "total_entries"
    }
}

