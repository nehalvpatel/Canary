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
    static func handleAction(rule: Rule, call: Call, finish: @escaping (Result<Any, Error>) -> ()) {
        let values: [String:String] = ["value1": rule.message(call: call)]
        let jsonData = try? JSONSerialization.data(withJSONObject: values)
        
        let url = URL(string: "https://maker.ifttt.com/trigger/\(rule.action.event)/with/key/\(rule.action.key)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
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
