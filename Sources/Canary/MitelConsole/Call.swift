//
//  Call.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import RegularExpressionDecoder

typealias CallDecoder = RegularExpressionDecoder<Call>
typealias CallPattern = RegularExpressionPattern<Call, Call.CodingKeys>

struct Call : Codable {
    var callerID: String = ""
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
    /// The duration of the call in seconds.
    var duration: TimeInterval {
        return Double(durationSeconds + (durationMinutes * 60) + (durationHours * 3600))
    }
    
    /// Returns a `Date` representing the date and time the call was initiated.
    ///
    /// - Parameter year: A year to append to the date, because the call log does not include it.
    /// - Returns: A new `Date`.
    func initiatedAt(year: Year) -> Date? {
        let components = DateComponents(year: year.integerValue, month: initiatedMonth, day: initiatedDay, hour: initiatedHour, minute: initiatedMinute, second: 0)
        return Calendar.current.date(from: components)
    }

    /// Returns a `CallDecoder` used to parse call logs.
    ///
    /// - Returns: A new `CallDecoder`.
    static func makeDecoder() throws -> CallDecoder {
        let pattern: CallPattern = #"(?<\#(.initiatedMonth)>\d+)\/(?<\#(.initiatedDay)>\d+)(?:\s+)(?<\#(.initiatedHour)>\d+):(?<\#(.initiatedMinute)>\d+)(?:\s+)(?<\#(.durationHours)>\d+):(?<\#(.durationMinutes)>\d+):(?<\#(.durationSeconds)>\d+)(?:\s+)(?<\#(.callingNumber)>(?:ATT)?\d+)(?:\s+)(?:\*)?(?<\#(.accessCode)>\d+)(?:\s+)(?<\#(.dialedNumber)>\d+)(?:\s+)(?<\#(.trunk)>T\d+)"#
        return try CallDecoder(pattern: pattern)
    }
}

extension CallDecoder {
    /// Returns a `Call` representing the input, with a Caller ID based off of a PhoneBook.
    ///
    /// - Parameter from: A call log line to parse.
    /// - Parameter phoneBook: A `PhoneBook` to use for Caller ID matching.
    func decode(from line: String, phoneBook: Config.PhoneBook) throws -> Call {
        var call = try self.decode(Call.self, from: line)
        call.callerID = phoneBook.callerID(for: call)
        return call
    }
}
