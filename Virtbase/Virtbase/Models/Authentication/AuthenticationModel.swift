//
//  AuthenticationModel.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 12.02.26.
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

enum AuthenticationState: CaseIterable {
    case authenticated
    case deauthenticated
    case processing
    case unknown
}

class AuthenticationModel: ObservableObject {
    
    @Published
    var state: AuthenticationState
    = AuthenticationState.unknown
    
    @Published
    var session: Session
    
    init() {
        // we use 'ephemeral' here, so we dont save any cookies
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = false

        let session = Session(
            configuration: configuration,
            interceptor: InterceptorModel()
        )
        self.session = session
    }
    
    func authenticate(
        token: String
    ) async throws {
        
        self.state =
        AuthenticationState.processing
        
        // first write token to keychain
        // if that fails we cancel
        try KeychainModel.write(
            token: token
        )
        
        let address = "https://virtbase.com/api/v1/kvm/owned"
        let result = await session.request(address)
            .validate(statusCode: 200..<300)
            .serializingData()
            .result

        let success: Bool
        switch result {
        case .success:
            success = true
        case .failure:
            success = false
        }

        switch AuthKeychainPolicy.outcomeAfterRemoteValidation(success: success) {
        case .validatedKeepSession:
            self.state = .authenticated
        case .invalidatedClearStoredKey:
            // Do not leave a rejected or failed-validation key in the keychain after we optimistically stored it.
            try? KeychainModel.delete()
            self.state = .deauthenticated
        }
    }
    
    func refresh() async {
        let address = "https://virtbase.com/api/v1/kvm/owned"
        let result = await session.request(address)
            .validate(statusCode: 200..<300)
            .serializingData()
            .result

        switch result {
        case .success:
            self.state = .authenticated
        case .failure:
            self.state = .deauthenticated
        }
    }
    
    func deauthenticate() throws {
        try KeychainModel.delete()
        
        self.state =
        AuthenticationState.deauthenticated
    }
}
