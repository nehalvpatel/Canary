//
//  Config.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial

typealias PhoneNumber = String

struct Config : Codable {
    /// A collection used for Caller ID purposes.
    struct PhoneBook : Codable {
        /// Should be something like `Room` or `Floor`, for when the number doesn't need to be specially labeled
        let prefix: String
        
        /// Should contain well-known phone numbers with names, such as ["ATT0"] = `Office` or ["238"] = `Laundry`
        let listings: [PhoneNumber:String]
    }

    /// The file path for the port to be monitored. For Linux systems, this would be something like `/dev/ttyUSB0`
    let portName: String
    
    let rules: [Rule]
    let phoneBook: PhoneBook
}

extension Config.PhoneBook {
    /// Returns the Caller ID for a call.
    ///
    /// - Parameter call: Call to determine Caller ID for.
    /// - Returns: The phone book entry matching the calling number, or else a generic in the format of (`unit` +  ` ` + `callingNumber`)
    func callerID(for call: Call) -> String {
        if let roomName = self.listings[call.callingNumber] {
            return roomName
        } else {
            return "\(self.prefix) \(call.callingNumber)"
        }
    }
}
