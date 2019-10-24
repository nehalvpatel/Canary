//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

print("Hello, World!")

let portName = "/dev/ttyUSB0"

let serialPort = SerialPort(path: portName)

do {
    print("Attempting to open port: \(portName)")
    try serialPort.openPort(toReceive: true, andTransmit: false)
    print("Serial port \(portName) opened successfully.")
    
    defer {
        serialPort.closePort()
        print("Port closed")
    }
    
    serialPort.setSettings(receiveRate: .baud1200, transmitRate: .baud1200, minimumBytesToRead: 1)
    
    let stringReceived = try serialPort.readLine()

    print(stringReceived)
} catch PortError.failedToOpen {
    print("Serial port \(portName) failed to open. You might need root permissions.")
} catch {
    print("Error: \(error)")
}

