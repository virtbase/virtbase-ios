//
//  ServerInformationViewModel.swift
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
import Alamofire
import Combine

class ServerInformationViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .unknown
    
    @Published
    var information: ServerInformation?
    
    func fetch(
        session: Session,
        server: Server
    ) async {
        self.status = .processing
        
        var components = URLComponents(string: Configuration.BASE_URL + "/servers/\(server.id)")
        components?.queryItems = [
            URLQueryItem(name: "expand", value: "node"),
            URLQueryItem(name: "expand", value: "datacenter"),
            URLQueryItem(name: "expand", value: "allocations")
        ]
        
        guard let address = components?.url?.absoluteString else {
            self.status = .failed
            return
        }
        
        guard let information = try? await session.request(
            address,
            method: .get
        )
        .validate()
        .serializingDecodable(ServerInformationResponse.self)
        .value.server else {
            self.status = .failed
            return
        }
        
        self.information = information
        self.status = .succeeded
    }
}
