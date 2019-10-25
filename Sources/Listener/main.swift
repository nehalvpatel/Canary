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
let trigger = Rule.Trigger(phoneNumber: "999")
let action = Rule.Action(service: .IFTTT, key: "", event: "emergency_called")
let glossary = Rule.Glossary(unit: "Room", dictionary: ["0": "Office", "199": "Lobby", "238": "Laundry"])
let rules: [Rule] = [Rule(place: "Budget Inn", trigger: trigger, action: action, glossary: glossary)]
let console: Console = Console(portName: "/dev/ttyUSB0", rules: rules)

do {
    let connection: Phone = try Phone(console, decoder: decoder)
    
    defer {
        connection.close()
        print("Port closed")
    }
    
    try connection.listen()
} catch PortError.failedToOpen {
    print("Serial port \(console.portName) failed to open. You might need root permissions.")
} catch PortError.deviceNotConnected {
    print("Device disconnected.")
} catch {
    print("Error: \(error)")
}
