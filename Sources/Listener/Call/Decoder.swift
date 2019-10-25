//
//  CallDecoder.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

/// https://talk.objc.io/episodes/S01E115-building-a-custom-xml-decoder

class CallDecoder: Decoder {
    var codingPath: [CodingKey] = []
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    var input: String = ""
    let year: Year
    
    /// Creates a new instance with the given `line` and `year`.
    ///
    /// - parameter year: The year the call took place.
    init(year: Year) {
        self.year = year
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        // TODO: handle error
        let groups = input.dictionaryByMatching(regex: #"(?<initiatedMonth>\d+)\/(?<initiatedDay>\d+)(?:\s+)(?<initiatedHour>\d+):(?<initiatedMinute>\d+)(?:\s+)(?<durationHours>\d+):(?<durationMinutes>\d+):(?<durationSeconds>\d+)(?:\s+)(?:ATT)?(?<callingNumber>\d+)(?:\s+)(?:\*)?(?<accessCode>\d+)(?:\s+)(?<dialedNumber>\d+)(?:\s+)T(?<trunkNumber>\d+)"#) ?? [:]
        
        if groups.count == 0 {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: codingPath, debugDescription: "The input didn't match the Call regular expression."))
        }
        
        return KeyedDecodingContainer(KDC(groups, year: year))
    }
    
    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        
        var allKeys: [Key] = []

        let groups: [String:String]
        let year: Year
        
        init(_ groups: [String:String], year: Year) {
            self.groups = groups
            self.year = year
        }
        
        func contains(_ key: Key) -> Bool {
            return groups[key.stringValue] != nil
        }
        
        func group(named: String) throws -> String {
            guard let group = groups[named] else {
                throw DecodingError.keyNotFound(Key(stringValue: named)!, DecodingError.Context(codingPath: codingPath, debugDescription: "TODO"))
            }
            return group
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }
        
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            fatalError()
        }
        
        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            let group = try self.group(named: key.stringValue)
            return group
        }
        
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            if key.stringValue == "duration" {
                let seconds = Int(try group(named: "durationSeconds"))!
                let minutes = Int(try group(named: "durationMinutes"))!
                let hours = Int(try group(named: "durationHours"))!
                return Double(seconds + (minutes * 60) + (hours * 3600))
            }
            
            fatalError()
        }
        
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            fatalError()
        }
        
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            fatalError()
        }
        
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            fatalError()
        }
        
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            fatalError()
        }
        
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            fatalError()
        }
        
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            fatalError()
        }
        
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            fatalError()
        }
        
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            fatalError()
        }
        
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            fatalError()
        }
        
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            fatalError()
        }
        
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            fatalError()
        }
        
        func decode(_ type: Date.Type, forKey key: Key) throws -> Date {
            if key.stringValue == "initiated" {
                let year: Int = self.year.value()
                let month: Int? = Int(try group(named: "initiatedMonth"))
                let day: Int? = Int(try group(named: "initiatedDay"))
                let hour: Int? = Int(try group(named: "initiatedHour"))
                let minute: Int? = Int(try group(named: "initiatedMinute"))
                
                let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: 0)
                guard let date = Calendar.current.date(from: components) else {
                    throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Could not parse when call was initiated."))
                }
                return date
            }
            
            fatalError()
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            if type == Date.self {
                return try decode(Date.self, forKey: key) as! T
            }
            
            fatalError()
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            fatalError()
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            fatalError()
        }
        
        func superDecoder() throws -> Decoder {
            fatalError()
        }
        
        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }
        
        
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
    
    
}
