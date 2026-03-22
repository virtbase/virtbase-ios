//
//  Invoice+Download.swift
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

extension Invoices {

    static func download(
        session: Session,
        invoice: Invoices.Invoice
    ) async throws -> URL {

        let address =
            "https://virtbase.com/api/v1/invoices/\(invoice.id)/download"

        let downloadable = try await session.request(address)
            .validate()
            .serializingDecodable(DownloadableInvoice.self)
            .value
        
        var normalized = downloadable.content
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
        
        if normalized.count % 4 != 0 {
            normalized.append(String(repeating: "=", count: 4 - normalized.count % 4))
        }

        guard let normalized = normalized.data(using: .utf8),
              let data = Data(base64Encoded: normalized, options: [.ignoreUnknownCharacters])
        else {
            throw NSError(domain: "InvoiceDownload", code: 1)
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent(downloadable.name)

        try data.write(to: url, options: .atomic)

        return url
    }
}
