//
//  Phone.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

class PhoneSystem {
    let port: SerialPort
    let decoder: CallDecoder
    let rules: [Rule]
    
    init(_ console: Console, decoder: CallDecoder) throws {
        self.port = SerialPort(path: console.portName)
        self.decoder = decoder
        self.rules = console.rules
        
        print("Attempting to open port: \(console.portName)")
        try port.openPort(toReceive: true, andTransmit: false)
        print("Serial port \(console.portName) opened successfully.")
        port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
    }
    
    func listen() throws {
        repeat {
            let call = try readCall()
            handleCall(call)
        } while true
    }
    
    func readCall() throws -> Call {
        var call: Call?
        
        while call == nil {
            let line = try port.readLine()
            print(line)
            decoder.input = line
            call = try? Call(from: decoder)
        }
        
        return call!
    }
    
    func handleCall(_ call: Call) {
        for rule in rules.matching(call) {
            let action = rule.action
            
            switch action.service {
                case .IFTTT:
                    IFTTT.handleAction(rule: rule, call: call) { result in
                        if case .failure(let error) = result {
                            print(error)
                        }
                    }
            }
        }
    }
}
