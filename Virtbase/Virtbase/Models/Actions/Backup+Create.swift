//
//  Backup+Create.swift
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

enum BackupCreationMode: String, Codable {
    case snapshot = "snapshot"
    case suspend = "suspend"
    case stop = "stop"
}

nonisolated struct BackupCreateRequest: Codable {
    let name: String
    let isLocked: Bool
    let mode: BackupCreationMode
}

extension Backup {
    static func create(
        session: Session,
        server: Server,
        name: String,
        locked: Bool,
        mode: BackupCreationMode
    ) async throws {

        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/backups"
        )

        let body = BackupCreateRequest(
            name: name,
            isLocked: locked,
            mode: mode
        )

        let _ = try await session.request(
            address,
            method: .post,
            parameters: body,
            encoder: JSONParameterEncoder.default
        )
        .validate()
        // We need this, otherwise Alamofire crashes
        .serializingData(emptyResponseCodes: [200])
        .value
    }
}
