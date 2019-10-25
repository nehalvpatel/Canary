//
//  Console.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation
import SwiftSerial

struct Console : Codable {
    let portName: String
    let rules: [Rule]
}
