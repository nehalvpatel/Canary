//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

import Commander
import SwiftSerial


func run(configFile: String) {
    do {
        let listener = try Listener(withConfigFrom: configFile)

        /// Ensures that the connection will be closed and the port is released.
        defer {
            listener.cleanup()
        }

        /// Starts a loop which will receive call logs. It only ends in case of an error.
        /// It parses calls, applies rule predicates, and executes their actions.
        try listener.start()
    } catch {
        Listener.handleError(error)
    }
}

let main = command(Option<String>("config-file", default: "config.json", description: "The configuration file."), run)

main.run()
