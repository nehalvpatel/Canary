//
//  ServiceHandler.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

protocol CanaryServiceHandler {
    static func execute(_ action: Canary.Rule.Action, for call: MitelConsole.Call) -> Void
}
