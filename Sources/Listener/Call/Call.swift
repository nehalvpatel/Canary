//
//  Call.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

struct Call : Codable, Hashable {
    let initiated: Date
    let duration: TimeInterval
    let callingNumber: String
    let accessCode: String
    let dialedNumber: String
    let trunkNumber: String
}
