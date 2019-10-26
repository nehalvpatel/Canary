//
//  IFTTT.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct IFTTT: ServiceHandler {
    struct Values {
        /// The dialer's Caller ID.
        let value1: String
        /// The dialed phone number that caused the action to trigger.
        let value2: PhoneNumber
        /// Not used yet.
        let value3: String?
    }
    
    static func execute(_ action: Rule.Action, call: Call, caller: String, finish: @escaping (Result<Any, Error>) -> ()) {
        let values = Values(value1: caller, value2: call.dialedNumber, value3: "")
        
        let url = URL(string: "https://maker.ifttt.com/trigger/\(action.event)/with/key/\(action.key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: values)
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil, error == nil else {
                finish(.failure(error!))
                return
            }
            
            finish(.success(()))
        }
        
        task.resume()
    }
}
