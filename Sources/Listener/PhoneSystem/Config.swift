//
//  Config.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial

struct Config : Codable {
    struct Glossary : Codable {
        let unit: String
        let known: [PhoneNumber:String]
    }
    
    let portName: String
    let rules: [Rule]
    let glossary: Glossary
}
