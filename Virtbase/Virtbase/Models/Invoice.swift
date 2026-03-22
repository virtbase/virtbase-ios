//
//  Invoice.swift
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

nonisolated
struct DownloadableInvoice: Codable {
    var name: String
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case name = "filename"
        case content = "content"
    }
}

nonisolated
struct Invoices: Codable {
    var invoices: [Invoice]
    
    nonisolated
    struct Invoice: Identifiable, Codable {
        var id: String
        
        var number: String
        var total: Double?
        var tax: Double?
        
        var refund: Bool?
        
        var created: Date?
        var updated: Date?
        var sent: Date?
        var paid: Date?
        var cancelled: Date?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case number = "number"
            case total = "total"
            case tax = "tax_amount"
            case refund = "reverse_charge"
            case created = "created_at"
            case updated = "updated_at"
            case sent = "sent_at"
            case paid = "paid_at"
            case cancelled = "cancelled_at"
        }
    }
}
