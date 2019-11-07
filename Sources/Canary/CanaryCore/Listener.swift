//
//  Listener.swift
//  Canary
//
//  Created by Nehal Patel on 11/7/19.
//

import Foundation

extension Canary {
    class Listener: MitelConsoleDelegate {
        let rules: [Rule]
        
        init(rules: [Rule]) {
            self.rules = rules
        }
        
        func mitelConsoleDidAttemptConnection(_ console: MitelConsole) {
            print("⌛ Attempting to open port: \(console.portName).")
        }
        
        func mitelConsoleDidEstablishConnection(_ console: MitelConsole) {
            print("✅ Serial port \(console.portName) opened successfully.")
            print()
        }
        
        func mitelConsoleDidCloseConnection(_ console: MitelConsole) {
            print("🛑 Port closed.")
        }
        
        /// Print the incoming data in a user-friendly way.
        func mitelConsole(_ console: MitelConsole, didReadLine line: String) {
            let lineTrimmed = line.trimmed
            guard lineTrimmed.isNotEmpty else { return }
            print(lineTrimmed)
        }
        
        /// Determine`Rule` matches for dialed number and execute any actions necessary for a `Call`.
        func mitelConsole(_ console: MitelConsole, didReadCall call: MitelConsole.Call) {
            rules.matching(call).forEach {
                $0.performActions(forCall: call)
            }
        }
    }
}
