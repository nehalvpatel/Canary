//
//  IFTTT.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

#if canImport(FoundationNetworking)
/// Required for Linux support.
import FoundationNetworking
#endif

struct IFTTT: ServiceHandler {
    struct WebhookBody : Codable {
        /// The dialer's Caller ID.
        let value1: String
        /// The dialed phone number that caused the action to trigger.
        let value2: PhoneNumber
        /// Not used yet.
        let value3: String
    }
    
    static func execute(_ action: Rule.Action, for call: Call) {
        do {
            let webhookURL = URL(string: "https://maker.ifttt.com/trigger/\(action.event)/with/key/\(action.key)")!
            let webhookBody = WebhookBody(value1: call.callerID, value2: call.dialedNumber, value3: "")
            var webhookRequest = URLRequest(url: webhookURL)
            webhookRequest.httpMethod = "POST"
            webhookRequest.httpBody = try JSONEncoder().encode(webhookBody)
            webhookRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: webhookRequest) { data, response, error in
                guard data != nil, error == nil else {
                    Listener.handleError(error!)
                    return
                }
            }
            
            task.resume()
        } catch let error {
            Listener.handleError(error)
        }
    }
}
