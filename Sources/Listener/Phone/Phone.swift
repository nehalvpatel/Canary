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
    
    init(_ port: String, decoder: CallDecoder) throws {
        self.port = SerialPort(path: portName)
        self.decoder = decoder
        
        print("Attempting to open port: \(portName)")
        try self.port.openPort(toReceive: true, andTransmit: false)
        print("Serial port \(portName) opened successfully.")
        self.port.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
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
    
    func close() {
        return self.port.closePort()
    }
}
