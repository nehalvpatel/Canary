//
//  Call.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import RegularExpressionDecoder

typealias CallDecoder = RegularExpressionDecoder<Call>
typealias CallPattern = RegularExpressionPattern<Call, Call.CodingKeys>

struct Call : Codable {
    let callingNumber: String
    let accessCode: Int
    let dialedNumber: PhoneNumber
    let trunk: String
    
    let initiatedMonth: Int
    let initiatedDay: Int
    let initiatedHour: Int
    let initiatedMinute: Int
    let durationHours: Int
    let durationMinutes: Int
    let durationSeconds: Int
    
    enum CodingKeys: String, CodingKey {
        case callingNumber
        case accessCode
        case dialedNumber
        case trunk
        
        case initiatedMonth
        case initiatedDay
        case initiatedHour
        case initiatedMinute
        case durationHours
        case durationMinutes
        case durationSeconds
    }
}

extension Call {
    func initiatedAt(year: Year) -> Date {
        let components = DateComponents(year: year.value(), month: initiatedMonth, day: initiatedDay, hour: initiatedHour, minute: initiatedMinute, second: 0)
        return Calendar.current.date(from: components)!
    }
    
    var duration: TimeInterval {
        return Double(durationSeconds + (durationMinutes * 60) + (durationHours * 3600))
    }
    
    static func makeDecoder() throws -> CallDecoder {
        let pattern: CallPattern = #"(?<\#(.initiatedMonth)>\d+)\/(?<\#(.initiatedDay)>\d+)(?:\s+)(?<\#(.initiatedHour)>\d+):(?<\#(.initiatedMinute)>\d+)(?:\s+)(?<\#(.durationHours)>\d+):(?<\#(.durationMinutes)>\d+):(?<\#(.durationSeconds)>\d+)(?:\s+)(?<\#(.callingNumber)>(?:ATT)?\d+)(?:\s+)(?:\*)?(?<\#(.accessCode)>\d+)(?:\s+)(?<\#(.dialedNumber)>\d+)(?:\s+)(?<\#(.trunk)>T\d+)"#
        return try CallDecoder(pattern: pattern)
    }
}
