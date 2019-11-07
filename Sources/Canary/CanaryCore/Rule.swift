//
//  Rule.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

extension Canary {
    struct Rule: Codable {
        struct Trigger: Codable {
            let phoneNumber: MitelConsole.PhoneNumber
        }
        
        enum Service: String, Codable {
            case IFTTT
        }
        
        struct Action: Codable {
            /// The service that will handle this action.
            let service: Service
            
            /// The API key to use for requests.
            let apiKey: String
            
            /// The specific event to trigger. For IFTTT, this would be the Webhook event name.
            let event: String
        }
        
        let trigger: Trigger
        let actions: [Action]
    }
}

extension Canary.Rule {
    /// Perform all actions associated with the trigger number.
    ///
    /// - Parameter call: The Call instance which activated the trigger.
    func performActions(forCall call: MitelConsole.Call) {
        self.actions.forEach { action in
            switch action.service {
            case .IFTTT: Canary.IFTTT.execute(action, for: call)
            }
        }
    }
}

extension Array where Element == Canary.Rule {
    /// Return an array of Rules that match a given Call.
    ///
    /// - Parameter call: A Call to test the trigger numbers with.
    func matching(_ call: MitelConsole.Call) -> [Canary.Rule] {
        return self.filter { rule -> Bool in
            return call.dialedNumber == rule.trigger.phoneNumber
        }
    }
}
