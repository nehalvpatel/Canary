//
//  Configuration.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

extension Canary {
    struct Configuration: Codable {
        /// The file path for the port to be monitored. For Linux systems, this would be something like `/dev/ttyUSB0`
        let portName: String
        /// A collection of Rules which describe what happens when a specific phone number is called.
        let rules: [Rule]
        /// A helper connection that provides well-known phone numbers along with their Caller IDs.
        let phoneBook: MitelConsole.PhoneBook
    }
}
