//
//  MitelConsole.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import Combine
import SwiftSerial
import RegularExpressionDecoder

class MitelConsole {
    let port: SerialPort
    let callDecoder: CallDecoder
    let callPublisher: CallPublisher
    
    init(portName: String) throws {
        self.port = SerialPort(path: portName)
        self.callDecoder = try Call.makeDecoder()
        self.callPublisher = CallPublisher()
        
        print("⌛ Attempting to open port: \(portName)")
        try port.openPort(toReceive: true, andTransmit: false)
        print("✅ Serial port \(portName) opened successfully.")
        port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
        print()
    }
    
    /// Starts scanning incoming data for calls.
    func listen() throws {
        DispatchQueue.global(qos: .userInitiated).async {
            repeat {
                do {
                    let call = try self.readCall()
                    self.callPublisher.send(call)
                } catch {
                    self.callPublisher.send(completion: Subscribers.Completion.failure(error))
                }
            } while true
        }
    }
    
    /// Reads incoming data and returns a `Call` when one is identified.
    func readCall() throws -> Call {
        var call: Call?
        
        while call == nil {
            let line = try port.readLine()
            call = try? callDecoder.decode(Call.self, from: line)
            printLine(line, call: call)
        }
        
        /// It's safe to use `!` here, because we've made sure it's not `nil` in the while loop above.
        return call!
    }
    
    /// Print the incoming data in a user-friendly way.
    func printLine(_ line: String, call: Call?) {
        print(line.trimmed, " ", "")
    }
}
