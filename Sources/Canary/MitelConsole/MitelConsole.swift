//
//  MitelConsole.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial
import RegularExpressionDecoder

class MitelConsole {
    let port: SerialPort
    let rules: [Rule]
    let phoneBook: Config.PhoneBook
    let callDecoder: CallDecoder
    
    init(_ config: Config) throws {
        self.port = SerialPort(path: config.portName)
        self.rules = config.rules
        self.phoneBook = config.phoneBook
        self.callDecoder = try Call.makeDecoder()
        
        print("⌛ Attempting to open port: \(config.portName)")
        try port.openPort(toReceive: true, andTransmit: false)
        print("✅ Serial port \(config.portName) opened successfully.")
        port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
        print()
    }
    
    /// Starts scanning incomring data for calls.
    func listen() throws {
        repeat {
            let call = try readCall()
            handleCall(call)
        } while true
    }
    
    /// Reads incoming data and returns a `Call` when one is identified.
    func readCall() throws -> Call {
        while true {
            let line = try port.readLine()
            
            if let call = try? callDecoder.decode(from: line, phoneBook: phoneBook) {
                printLine(line, indicator: rules.matching(call).isNotEmpty ? "🛎️" : "➜")
                return call
            } else {
                printLine(line, indicator: "➜")
            }
        }
    }
    
    /// Determine`Rule` matches for dialed number and execute any actions necessary for a `Call`.
    func handleCall(_ call: Call) {
        rules.matching(call).forEach {
            $0.performActions(forCall: call)
        }
    }
    
    /// Print the incoming data in a user-friendly way.
    func printLine(_ line: String, indicator: Character) {
        guard line.trimmed.isNotEmpty else {
            return
        }
        
        print("\(indicator) \(line.trimmed)")
    }
}
