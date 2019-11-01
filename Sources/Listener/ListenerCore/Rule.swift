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
    
    struct Action : Codable {
        enum Service: String, Codable {
            case IFTTT
        }
        
        let service: Service
        
        /// The API key to use for Webhook requests.
        let key: String
        
        /// The Webhook event to trigger.
        let event: String
    }
    
    let trigger: Trigger
    let actions: [Action]
}

extension Rule {
    /// Perform all actions associated with the trigger number.
    ///
    /// - Parameter call: The Call instance which activated the trigger.
    func performActions(forCall call: Call) {
        self.actions.forEach { action in
            switch action.service {
            case .IFTTT: IFTTT.execute(action, for: call)
            }
        }
    }
}

extension Array where Element == Rule {
    /// Return an array of Rules that match a given Call.
    ///
    /// - Parameter call: A Call to test the trigger numbers with.
    func matching(_ call: Call) -> [Rule] {
        return self.filter { rule -> Bool in
            return call.dialedNumber == rule.trigger.phoneNumber
        }
    }
}
