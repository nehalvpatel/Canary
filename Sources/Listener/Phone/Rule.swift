//
//  Rule.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

typealias PhoneNumber = String

struct Rule : Codable {
    struct Trigger : Codable {
        let phoneNumber: PhoneNumber
    }
    
    enum Service: String, Codable {
        case IFTTT
    }
    
    struct Action : Codable {
        let service: Service
        let key: String
        let event: String
    }
    
    struct Glossary : Codable {
        let unit: String
        let dictionary: [PhoneNumber:String]
    }
    
    let place: String
    let trigger: Trigger
    let action: Action
    let glossary: Glossary
    
    func message(call: Call) -> String {
        let suffix = "dialed \(call.dialedNumber) at \(place)."
        
        if let location = glossary.dictionary[call.callingNumber] {
            return "\(location) \(suffix)"
        } else {
            return "\(glossary.unit) \(call.callingNumber) \(suffix)"
        }
    }
}

extension Array where Element == Rule {
    func matching(_ call: Call) -> [Rule] {
        return self.filter { rule -> Bool in
            return call.dialedNumber == rule.trigger.phoneNumber
        }
    }
}
