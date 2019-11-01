//
//  Rule.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

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
    
    let trigger: Trigger
    let actions: [Action]
}

extension Rule {
    func performActions(forCall call: Call, glossary: Config.Glossary) {
        self.actions.forEach { action in
            switch action.service {
                case .IFTTT:
                    IFTTT.execute(action, call: call, caller: glossary.callerID(for: call)) { result in
                        if case .failure(let error) = result { Listener.handleError(error) }
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
