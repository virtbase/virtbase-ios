//
//  BackupsViewModel.swift
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

// We need this, for proper json parsing
nonisolated struct BackupsEnvelope: Decodable {
    let backups: [Backup]
}

class BackupsViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .unknown
    
    @Published
    var backups: [Backup]?
    
    func fetch(
        session: Session,
        server: Server
    ) async {
        self.status = .processing
        
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/backups"
            + "?per_page=9007199254740991"
        )
        
        // for some reason this specific enpoints uses iso8601
        // most others use secondsSinceOrigin
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let backups = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(
            BackupsEnvelope.self,
            decoder: decoder
        )
        .value.backups else {
            self.status = .failed
            return
        }
    
        self.backups = backups
        self.status = .succeeded
    }
}
