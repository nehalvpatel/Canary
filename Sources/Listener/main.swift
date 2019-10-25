//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

let decoder = CallDecoder(year: .current(Calendar.current))

do {
    let url = URL(fileURLWithPath: CommandLine.arguments[1])
    let file: FileHandle = try FileHandle(forReadingFrom: url)
    let data = file.readDataToEndOfFile()
    file.closeFile()

    let testDec = JSONDecoder()
    let console = try testDec.decode(Console.self, from: data)

    let connection: Phone = try Phone(console, decoder: decoder)
    
    defer {
        connection.close()
        print("Port closed")
    }
    
    try connection.listen()
} catch PortError.failedToOpen {
    print("Serial port failed to open. You might need root permissions.")
} catch PortError.deviceNotConnected {
    print("Device disconnected.")
} catch {
    print("Error: \(error)")
}
