//
//  Listener.swift
//  Listener
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation
import Combine
import Commander
import SwiftSerial
import RegularExpressionDecoder

struct Listener {
    
    let config: Config
    let connection: MitelConsole
    
    init(configFilePath: String) throws {
        self.config = try Config.makeConfigFromFile(path: configFilePath)
        self.connection = try MitelConsole(portName: config.portName)
    }

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
//    func makeConnection(withConfigFrom configFilePath: String) throws -> MitelConsole {
//        let configFileURL = URL(fileURLWithPath: configFilePath)
//        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
//        let configData = configFile.readDataToEndOfFile()
//        configFile.closeFile()
//
//        self.config = try JSONDecoder().decode(Config.self, from: configData)
//        return try MitelConsole(portName: config.portName)
//    }
    
    /// Starts parsing incoming call logs.
    ///
    /// - Parameter with: A MitelConsole instance to listen with.
    func startListening() throws {
        /// Ensures that the connection will be closed and the port is released.
        defer {
            connection.port.closePort()
            print("🛑 Port closed.")
        }
        
        let _ = connection.callPublisher
            .map({ $0.withCallerID(using: self.config.glossary) })
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: self.handleCompletion(_:), receiveValue: self.handleCall(_:))
        
        /// Starts a loop which will receive call logs. It only ends in case of an error.
        /// It parses calls, applies rule predicates, and executes their actions.
        try connection.listen()
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) -> Void {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            Listener.handleError(error)
            break
        }
    }
    
    /// Determine`Rule` matches for dialed number and execute any actions necessary for a `Call`.
    func handleCall(_ call: Call) {
        config.rules.matching(call).forEach {
            $0.performActions(forCall: call)
        }
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

extension Call {
    func withCallerID(using glossary: Config.Glossary) -> Call {
        var updatedCall = self
        updatedCall.callerID = glossary.callerID(for: updatedCall)
        return updatedCall
    }
}
