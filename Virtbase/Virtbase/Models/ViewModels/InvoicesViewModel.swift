//
//  InvoicesViewModel.swift
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

class InvoicesViewModel: ObservableObject {
    
    @Published
    var status: RequestStatus = .unknown
    
    @Published
    var invoices: [Invoices.Invoice]?
    
    func fetch(
        session: Session
    ) async {
        self.status = .processing

        // TODO: Implement pagination
        let address = (
            Configuration.BASE_URL
            + "/invoices"
            + "?per_page=100"
        )
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            self.invoices = try await session.request(
                address,
                method: .get
            )
            .validate()
            .serializingDecodable(
                Invoices.self,
                decoder: decoder
            )
            .value.invoices
            
            self.status = .succeeded
        } catch {
            self.status = .failed
        }
    }
}
