//
//  Listener.swift
//  Listener
//
//  Created by Nehal Patel on 10/25/19.
//

import Foundation

struct Listener {
    let connection: PhoneSystem
    
    init(withConfigFrom configFilePath: String) throws {
        let configFileURL = URL(fileURLWithPath: configFilePath)
        let configFile: FileHandle = try FileHandle(forReadingFrom: configFileURL)
        let configData = configFile.readDataToEndOfFile()
        configFile.closeFile()
        
        let config = try JSONDecoder().decode(Config.self, from: configData)
        let decoder = CallDecoder(year: .current(Calendar.current))
        self.connection = try PhoneSystem(config, decoder: decoder)
    }
    
    func start() throws {
        try connection.listen()
    }
    
    func cleanup() {
        connection.port.closePort()
        print("Port closed")
    }
}
