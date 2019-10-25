//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

//let inputString: String = "  10/23 19:57  04:20:58 115   9   13125431294                 T075"

let portName = "/dev/ttyUSB0"
let decoder = CallDecoder(year: .current(Calendar.current))

do {
    let console: Phone = try Phone(portName, decoder: decoder)

    defer {
        console.close()
        print("Port closed")
    }
    
    repeat {
        let call = try console.nextCall()
        print(call)
    } while true
} catch PortError.failedToOpen {
    print("Serial port \(portName) failed to open. You might need root permissions.")
} catch PortError.deviceNotConnected {
    print("Device disconnected.")
} catch {
    print("Error: \(error)")
}
