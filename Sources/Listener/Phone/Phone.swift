//
//  Phone.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

class Phone {
    let port: SerialPort
    let decoder: CallDecoder
    let rules: [Rule]
    
    init(_ console: Console, decoder: CallDecoder) throws {
        self.port = SerialPort(path: console.portName)
        self.decoder = decoder
        self.rules = console.rules
        
        print("Attempting to open port: \(self.port)")
        try self.port.openPort(toReceive: true, andTransmit: false)
        print("Serial port \(self.port) opened successfully.")
        self.port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
    }
    
    func listen() throws {
        repeat {
            let call = try self.nextCall()
            self.handleCall(call)
        } while true
    }
    
    func nextCall() throws -> Call {
        var call: Call?
        
        while call == nil {
            let line = try self.port.readLine()
            print(line)
            self.decoder.input = line
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
    
    func close() {
        return self.port.closePort()
    }
}
