//
//  Listener.swift
//  Listener
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation
import Commander
import SwiftSerial
import RegularExpressionDecoder

struct Listener {

    static func parseArguments(handler: @escaping (String) throws -> ()) throws {
        let configFileOption = Option<String>("config-file", default: "config.json", description: "The configuration file.")
        let main = command(configFileOption, handler)
        main.run()
    }
    
    static func makeConnection(withConfigFrom configFilePath: String) throws -> MitelConsole {
        let configFileURL = URL(fileURLWithPath: configFilePath)
        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
        let configData = configFile.readDataToEndOfFile()
        configFile.closeFile()
        
        let config = try JSONDecoder().decode(Config.self, from: configData)
        return try MitelConsole(config)
    }
    
    static func startListening(with connection: MitelConsole) throws {
        /// Ensures that the connection will be closed and the port is released.
        defer {
            connection.port.closePort()
            print("🛑 Port closed.")
        }

        /// Starts a loop which will receive call logs. It only ends in case of an error.
        /// It parses calls, applies rule predicates, and executes their actions.
        try connection.listen()
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
