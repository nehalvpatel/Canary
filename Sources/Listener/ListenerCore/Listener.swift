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

    /// Parse the command-line arguments for the configuration file's location.
    ///
    /// - Parameter completionHandler: A closure which is called with the configuration file's location.
    static func parseArguments(completionHandler: @escaping (String) -> ()) {
        let configFileOption = Option<String>("config-file", default: "config.json", description: "The configuration file.")
        let commandPrompt = command(configFileOption, completionHandler)
        commandPrompt.run()
    }
    
    /// Establish a MitelConsole connection based off a configuration file.
    ///
    /// - Parameter withConfigFrom: The configuration file's path.
    static func makeConnection(withConfigFrom configFilePath: String) throws -> MitelConsole {
        let configFileURL = URL(fileURLWithPath: configFilePath)
        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
        let configData = configFile.readDataToEndOfFile()
        configFile.closeFile()
        
        let config = try JSONDecoder().decode(Config.self, from: configData)
        return try MitelConsole(config)
    }
    
    /// Starts parsing incoming call logs.
    ///
    /// - Parameter with: A MitelConsole instance to listen with.
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
    
    /// Pretty-prints user friendly errors.
    ///
    /// - Parameter error: An error that was caught.
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
