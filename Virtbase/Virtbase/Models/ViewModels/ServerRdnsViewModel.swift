//
//  ServerRdnsViewModel.swift
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
import Alamofire
import Combine

class ServerRdnsViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .processing
    
    @Published
    var records: [RdnsRecord]?
    
    @MainActor
    private func setFailed() {
        status = .failed
    }
    
    func fetch(
        session: Session,
        server: Server
    ) async {
        self.status = .processing
        
        do {
            let records = try await RdnsRecord.list(
                session: session,
                server: server
            )
            
            self.records = records
            self.status = .succeeded
        } catch {
            setFailed()
        }
    }
    
    func upsertRecord(
        session: Session,
        server: Server,
        ip: String,
        hostname: String
    ) async {
        self.status = .processing
        
        do {
            _ = try await RdnsRecord.upsert(
                session: session,
                server: server,
                hostname: hostname,
                ip: ip
            )
            
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
    
    func deleteRecord(
        session: Session,
        server: Server,
        record: RdnsRecord
    ) async {
        self.status = .processing
        
        do {
            try await RdnsRecord.delete(
                session: session,
                server: server,
                id: record.id
            )
            
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
}

