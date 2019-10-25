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
        let url = URL(fileURLWithPath: configFilePath)
        let file: FileHandle = try FileHandle(forReadingFrom: url)
        let data = file.readDataToEndOfFile()
        file.closeFile()
        
        let testDec = JSONDecoder()
        let console = try testDec.decode(Console.self, from: data)

        let decoder = CallDecoder(year: .current(Calendar.current))
        connection = try PhoneSystem(console, decoder: decoder)
    }
    
    func start() throws {
        try connection.listen()
    }
    
    func cleanup() {
        connection.port.closePort()
        print("Port closed")
    }
}
