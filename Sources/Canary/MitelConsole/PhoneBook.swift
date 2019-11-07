//
//  PhoneBook.swift
//  Canary
//
//  Created by Nehal Patel on 11/6/19.
//

import Foundation

/// A collection used for Caller ID purposes.
extension MitelConsole {
    typealias PhoneNumber = String

    struct PhoneBook: Codable {
        /// Should be something like `Room` or `Floor`, for when the number doesn't need to be specially labeled
        let prefix: String
        
        /// Should contain well-known phone numbers with names, such as ["ATT0"] = `Office` or ["238"] = `Laundry`
        let listings: [PhoneNumber:String]
    }
}

extension MitelConsole.PhoneBook {
    /// Returns the Caller ID for a call.
    ///
    /// - Parameter call: Call to determine Caller ID for.
    /// - Returns: The phone book entry matching the calling number, or else a generic in the format of (`unit` +  ` ` + `callingNumber`)
    func callerID(for call: MitelConsole.Call) -> String {
        if let roomName = self.listings[call.callingNumber] {
            return roomName
        } else {
            return "\(self.prefix) \(call.callingNumber)"
        }
    }
}
