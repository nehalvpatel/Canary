//
//  main.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

Canary.parseArguments() { configFilePath in
    do {
        let connection = try Canary.makeConnection(withConfigFrom: configFilePath)
        try Canary.startListening(with: connection)
    } catch {
        Canary.handleError(error)
    }
}
