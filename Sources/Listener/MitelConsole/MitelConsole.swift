//
//  MitelConsole.swift
//  Listener
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
    let glossary: Config.Glossary
    let callDecoder: CallDecoder
    
    init(_ config: Config) throws {
        self.port = SerialPort(path: config.portName)
        self.rules = config.rules
        self.glossary = config.glossary
        self.callDecoder = try Call.makeDecoder()
        
        print("⌛ Attempting to open port: \(config.portName)")
        try port.openPort(toReceive: true, andTransmit: false)
        print("✅ Serial port \(config.portName) opened successfully.")
        port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
        print()
    }
    
    func listen() throws {
        repeat {
            let call = try readCall()
            handleCall(call)
        } while true
    }
    
    func printLine(_ line: String, call: Call?) {
        if !line.trimmed.isEmpty {
            let indicator = call != nil ? "🛎️" : "➜"
            print("\(indicator) \(line.trimmed)")
        }
    }
    
    func readCall() throws -> Call {
        var call: Call?
        
        while call == nil {
            let line = try port.readLine()
            call = try? callDecoder.decode(Call.self, from: line)
            printLine(line, call: call)
        }
        
        call!.callerID = glossary.callerID(for: call!)
        
        return call!
    }
    
    func handleCall(_ call: Call) {
        rules.matching(call).forEach {
            $0.performActions(forCall: call)
        }
    }
}
