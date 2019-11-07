//
//  Canary.swift
//  Canary
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation
import Commander
import SwiftSerial
import RegularExpressionDecoder

struct Canary {
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
    /// - Parameter withConfigurationFrom: The configuration file's path.
    static func makeConnection(withConfigurationFrom configFilePath: String) throws -> MitelConsole {
        let configFileURL = URL(fileURLWithPath: configFilePath)
        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
        let configData = configFile.readDataToEndOfFile()
        configFile.closeFile()
        
        let configuration = try JSONDecoder().decode(Configuration.self, from: configData)
        let delegate = Listener(rules: configuration.rules)
        
        return try MitelConsole(configuration.portName, phoneBook: configuration.phoneBook, delegate: delegate)
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
