//
//  ServiceHandler.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

protocol ServiceHandler {
    static func execute(_ action: Rule.Action, for call: Call) -> Void
}
