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
    
    let place: String
    let trigger: Trigger
    let actions: [Action]
}

extension Rule {
    func message(for call: Call, glossary: Config.Glossary) -> String {
        let suffix = "dialed \(call.dialedNumber) at \(place)."
        
        if let location = glossary.known[call.callingNumber] {
            return "\(location) \(suffix)"
        } else {
            return "\(glossary.unit) \(call.callingNumber) \(suffix)"
        }
    }

    func performActions(forCall call: Call, glossary: Config.Glossary) {
        self.actions.forEach { action in
            let message = self.message(for: call, glossary: glossary)
            
            switch action.service {
                case .IFTTT:
                    IFTTT.execute(action, message: message, call: call) { result in
                        if case .failure(let error) = result {
                            print("⚠️ \(error)")
                        }
                    }
            }
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
