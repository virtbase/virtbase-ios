//
//  InterceptorModel.swift
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

final class InterceptorModel: RequestInterceptor {
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        
        request.headers.update(name: "Accept", value: "application/json")
        request.headers.update(name: "Content-Type", value: "application/json")
        request.headers.update(name: "User-Agent", value: "Virtbase/1.0")
        request.headers.update(name: "Origin", value: "https://virtbase.com")
        
        if let token = try? KeychainModel.read() {
            request.headers.update(name: "X-Virtbase-API-Key", value: token)
        }
        
        completion(.success(request))
    }
}
