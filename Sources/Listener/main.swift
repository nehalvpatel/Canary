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
    let configFilePath: String = CommandLine.arguments[2]
    
    let listener = try Listener(withConfigFrom: configFilePath)
    
    /// Closes connection and ensures the port is released.
    defer {
        listener.cleanup()
    }
    
    /// Starts a loop which will parse incoming logs from the phone system, apply Rule predicates, and execute their actions.
    /// This will only end in case of an error or the user pressing CTRL-C.
    try listener.start()

} catch PortError.failedToOpen {
    print("Serial port failed to open. You might need root permissions.")
} catch PortError.deviceNotConnected {
    print("Device disconnected.")
} catch {
    print("Error: \(error)")
}
