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
    static func execute(_ action: Rule.Action, message: String, call: Call, finish: @escaping (Result<Any, Error>) -> ()) {
        let values: [String:String] = ["value1": message]
        let json = try? JSONSerialization.data(withJSONObject: values)
        
        let url = URL(string: "https://maker.ifttt.com/trigger/\(action.event)/with/key/\(action.key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = json
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
