//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

Listener.parseArguments() { configFilePath in
    do {
        let connection = try Listener.makeConnection(withConfigFrom: configFilePath)
        try Listener.startListening(with: connection)
    } catch {
        Listener.handleError(error)
    }
}
