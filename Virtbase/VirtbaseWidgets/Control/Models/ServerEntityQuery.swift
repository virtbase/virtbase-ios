//
//  ServerEntityQuery.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 01.03.26.
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
import AppIntents

struct ServerEntityQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [ServerEntity] {
        return try await fetchServers().filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [ServerEntity] {
        return try await fetchServers()
    }

    private func fetchServers() async throws -> [ServerEntity] {
        let session = Session(
            configuration: .ephemeral,
            interceptor: InterceptorModel()
        )
        
        let servers = try await session.request(
            "https://virtbase.com/api/v1/kvm/owned",
            method: .get
        )
        .validate()
        .serializingDecodable([Server].self)
        .value

        return servers.map { ServerEntity(id: $0.id, name: $0.name, server: $0) }
    }
}
