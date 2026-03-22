//
//  KeychainModel.swift
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
import Security

enum KeychainError: LocalizedError {
    
    case unknown
    // something happened
    // that shouldnt have happened
    // TODO: make verbose
    
    case corrupt
    // data fucked for some reason
    // probably wont ever happen
    
    // read was called before
    // anything was written to keychain
    // useful for checking session
    case empty
}

final class KeychainModel {

    private static let service = "com.virtbase.Virtbase"
    private static let account = "com.virtbase.Session"

    // resolves the team id at runtime by inserting a throwaway keychain item
    // and reading the access group apple automatically assigns to it
    // holy yap yap yap yap
    private static var teamID: String? {
        let query: [CFString: Any] = [
            kSecClass:            kSecClassGenericPassword,
            kSecAttrService:      "bundleSeedID",
            kSecAttrAccount:      "bundleSeedID",
            kSecReturnAttributes: true
        ]

        SecItemAdd(query as CFDictionary, nil)

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        SecItemDelete(query as CFDictionary)

        guard let attrs = result as? [CFString: Any],
              let accessGroup = attrs[kSecAttrAccessGroup] as? String
        else { return nil }

        return accessGroup.components(separatedBy: ".").first
    }

    private static var accessGroup: String? {
        guard let id = teamID else { return nil }
        return "\(id).com.virtbase.Virtbase"
    }

    // base query used by all three operations
    // identifies the keychain item by service + account
    // access group injected when resolvable to enable widget sharing
    private static var baseQuery: [CFString: Any] {
        var query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        if let group = accessGroup {
            query[kSecAttrAccessGroup] = group
        }
        return query
    }

    static func write(token: String) throws {
        
        // encode token to utf8 before storing
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.corrupt
        }

        var query = baseQuery
        query[kSecValueData] = data
        query[kSecAttrAccessible] = kSecAttrAccessibleWhenUnlockedThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            let update: [CFString: Any] = [kSecValueData: data]
            guard SecItemUpdate(baseQuery as CFDictionary, update as CFDictionary) == errSecSuccess else {
                throw KeychainError.unknown
            }
        } else if status != errSecSuccess {
            throw KeychainError.unknown
        }
    }

    static func read() throws -> String {
        var query = baseQuery
        query[kSecReturnData] = true
        query[kSecMatchLimit] = kSecMatchLimitOne

        var result: AnyObject?
        switch SecItemCopyMatching(query as CFDictionary, &result) {
        case errSecSuccess:
            guard let data = result as? Data,
                  let token = String(data: data, encoding: .utf8) else {
                throw KeychainError.corrupt
            }
            return token
        case errSecItemNotFound:
            throw KeychainError.empty
        default:
            throw KeychainError.unknown
        }
    }

    static func delete() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown
        }
    }
}
