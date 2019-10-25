//
//  ServiceHandler.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

protocol ServiceHandler {
    static func handleAction(rule: Rule, call: Call, finish: @escaping (Result<Any, Error>) -> ()) -> Void
}
