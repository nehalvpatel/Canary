//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import SwiftSerial

do {
    /// `arguments[1]` is going to be the string literal `--config-file`.
    /// It's safe to hard-code this, because we only have one possible argument for now.
    let listener = try Listener(withConfigFrom: CommandLine.arguments[2])
    
    /// Ensures that the connection will be closed and the port is released.
    defer {
        listener.cleanup()
    }
    
    /// Starts a loop which will receive call logs. It only ends in case of an error.
    /// It parses calls, applies rule predicates, and executes their actions.
    try listener.start()
    
} catch PortError.failedToOpen {
    print("Serial port failed to open. You might need root permissions.")
} catch PortError.deviceNotConnected {
    print("Device disconnected.")
} catch {
    print("Error: \(error)")
}
