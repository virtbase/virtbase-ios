//
//  ServerGraphViewModel.swift
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
import Alamofire
import Combine

class ServerGraphViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .unknown
    
    @Published
    var samples: [ServerGraph]?
    
    func fetch(
        session: Session,
        server: Server
    ) async {
        self.status = .processing
        
        let address = (
            "https://virtbase.com/api/v1"
            + "/kvm/\(server.id)/graphs"
            + "?timeframe=hour"
        )
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        guard let samples = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(
            [ServerGraph].self,
            decoder: decoder
        )
        .value else {
            self.status = .failed
            return
        }
        
        self.samples = samples
        self.status = .succeeded
    }
}
