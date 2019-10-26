//
//  Listener.swift
//  Listener
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation
import SwiftSerial
import RegularExpressionDecoder

struct Listener {
    let connection: PhoneSystem
    
    init(withConfigFrom configFilePath: String) throws {
        let configFileURL = URL(fileURLWithPath: configFilePath)
        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
        let configData = configFile.readDataToEndOfFile()
        configFile.closeFile()
        
        let config = try JSONDecoder().decode(Config.self, from: configData)
        self.connection = try PhoneSystem(config)
    }
    
    func start() throws {
        try connection.listen()
    }
    
    func cleanup() {
        connection.port.closePort()
        print("🛑 Port closed.")
    }
    
    static func handleError(_ error: Error) {
        switch error {
            case PortError.failedToOpen:
                print("⚠️ Serial port failed to open. You might need root permissions.")
            case PortError.deviceNotConnected:
                print("🔌 Device disconnected.")
            default:
                print("❗ \(type(of: error)): \(error)")
        }
    }
}
