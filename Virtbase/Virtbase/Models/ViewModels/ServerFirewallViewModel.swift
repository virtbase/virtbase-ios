//
//  ServerFirewallViewModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 15.03.26.
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

class FirewallViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .processing
    
    @Published
    var options: FirewallOptions?
    
    @Published
    var rules: [FirewallRule]?
    
    @MainActor
    private func setFailed() {
        self.status = .failed
    }
   
    func fetch(
        session: Session,
        server: Server
    ) async {
        self.status = .processing
        
        let address_options = (
            "https://virtbase.com/api/v1/kvm/"
            + "\(server.id)/firewall/options"
        )
        
        let address_rules = (
            "https://virtbase.com/api/v1/kvm/"
            + "\(server.id)/firewall/rules"
        )
        
        guard let options = try? await session.request(
            address_options,
            method: .get
        )
        .validate()
        .serializingDecodable(FirewallOptions.self)
        .value else {
            self.status = .failed
            return
        }
        
        guard let rules = try? await session.request(
            address_rules,
            method: .get
        )
        .validate()
        .serializingDecodable([FirewallRule].self)
        .value else {
            self.status = .failed
            return
        }
    
        self.options = options
        self.rules = rules
        self.status = .succeeded
    }
    
    func deleteRule(
        session: Session,
        server: Server,
        rule: FirewallRule
    ) async {
        self.status = .processing
        
        do {
            try await FirewallRule.delete(
                session: session,
                server: server,
                pos: rule.position,
                digest: rule.digest
            )
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
    
    func moveRule(
        session: Session,
        server: Server,
        rule: FirewallRule,
        moveto: Int
    ) async {
        self.status = .processing
        
        do {
            try await FirewallRule.move(
                session: session,
                server: server,
                pos: rule.position,
                moveto: moveto,
                digest: rule.digest
            )
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
    
    func updateRule(
        session: Session,
        server: Server,
        pos: Int,
        request: FirewallRuleUpdateRequest
    ) async {
        self.status = .processing
        
        do {
            try await FirewallRule.update(
                session: session,
                server: server,
                pos: pos,
                request: request
            )
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
    
    func createRule(
        session: Session,
        server: Server,
        request: FirewallRuleCreateRequest
    ) async {
        self.status = .processing
        
        do {
            try await FirewallRule.create(
                session: session,
                server: server,
                request: request
            )
            await fetch(session: session, server: server)
        } catch {
            setFailed()
        }
    }
}
