//
//  ServiceHandler.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

protocol ServiceHandler {
    static func execute(_ action: Rule.Action, message: String, call: Call, finish: @escaping (Result<Any, Error>) -> ()) -> Void
}
