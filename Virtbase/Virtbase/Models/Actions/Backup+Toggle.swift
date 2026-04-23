//
//  Backup+Toggle.swift
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
import Alamofire
import Combine

nonisolated struct BackupUpdateRequest: Encodable {
    let name: String
    let isLocked: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case isLocked = "is_locked"
    }
}

extension Backup {
    static func toggle(
        session: Session,
        server: Server,
        backup: Backup
    ) async throws {
        let address = (
            Configuration.BASE_URL
            + "/servers/\(server.id)"
            + "/backups/\(backup.id)"
        )
        
        let request = BackupUpdateRequest(
            name: backup.name,
            isLocked: !(backup.locked ?? false)
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
