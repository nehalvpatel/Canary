//
//  [Rule]+matching.swift
//  Listener
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation

extension Array where Element == Rule {
    func matching(_ call: Call) -> [Rule] {
        return self.filter { rule -> Bool in
            return call.dialedNumber == rule.trigger.phoneNumber
        }
    }
}
