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
    func caller(for call: Call) -> String {
        if let roomName = self.phoneBook[call.callingNumber] {
            return roomName
        } else {
            return "\(self.unit) \(call.callingNumber)"
        }
    }
}
