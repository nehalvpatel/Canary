//
//  Config.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial

struct Config : Codable {
    let portName: String
    let rules: [Rule]
}
