//
//  ServiceHandler.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

protocol ServiceHandler {
    static func execute(_ action: Rule.Action, call: Call, caller: String, finish: @escaping (Result<Any, Error>) -> ()) -> Void
}
