//
//  Config.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial

struct Config : Codable {
    struct Glossary : Codable {
        let unit: String
        let phoneBook: [PhoneNumber:String]
    }

    let portName: String
    let rules: [Rule]
    let glossary: Glossary
}

extension Config.Glossary {
    /// Returns the Caller ID for a call.
    ///
    /// - Parameter call: Call to determine Caller ID for.
    /// - Returns: The phone book entry matching the calling number, or else a generic in the format of (`unit` +  ` ` + `callingNumber`)
    func callerID(for call: Call) -> String {
        if let roomName = self.phoneBook[call.callingNumber] {
            return roomName
        } else {
            return "\(self.unit) \(call.callingNumber)"
        }
    }
}
