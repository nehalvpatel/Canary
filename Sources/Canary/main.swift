//
//  main.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

Canary.parseArguments() { configurationFilePath in
    do {
        let phoneSystem = try Canary.makeConnection(withConfigurationFrom: configurationFilePath)
        try phoneSystem.establishConnection()
        try phoneSystem.startListening()
    } catch {
        Canary.handleError(error)
    }
}
