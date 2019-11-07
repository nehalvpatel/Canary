//
//  MitelConsole.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial
import RegularExpressionDecoder

class MitelConsole {
    let delegate: MitelConsoleDelegate
    let portName: String
    let port: SerialPort
    let phoneBook: PhoneBook
    let callDecoder: CallDecoder
    
    init(_ portName: String, phoneBook: PhoneBook, delegate: MitelConsoleDelegate) throws {
        self.portName = portName
        self.phoneBook = phoneBook
        self.delegate = delegate
        self.port = SerialPort(path: portName)
        self.callDecoder = try Call.makeDecoder()
    }
    
    /// Attempts to connect to the serial port.
    func establishConnection() throws {
        delegate.mitelConsoleDidAttemptConnection(self)
        try port.openPort(toReceive: true, andTransmit: false)
        delegate.mitelConsoleDidEstablishConnection(self)
        port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
    }
    
    /// Starts parsing incoming serial data to find calls.
    func startListening() throws {
        
        /// Ensures that the connection will be closed and the port is released.
        defer {
            port.closePort()
            delegate.mitelConsoleDidCloseConnection(self)
        }

        /// Starts a loop which will receive call logs. It only ends in case of an error.
        while true {
            let line = try port.readLine()
            delegate.mitelConsole(self, didReadLine: line)
            
            if let call = try? callDecoder.decode(from: line, phoneBook: phoneBook) {
                delegate.mitelConsole(self, didReadCall: call)
            }
        }
    }
}
