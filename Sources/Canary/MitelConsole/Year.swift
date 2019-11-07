//
//  Year.swift
//  Canary
//
//  Created by Nehal Patel on 10/24/19.
//

import Foundation

extension MitelConsole {
    public enum Year {
        case current(Calendar)
        case custom(Int)
        
        /// The Int value of the year.
        var integerValue: Int {
            switch self {
            case .current(let calendar):
                return calendar.component(.year, from: Date())
            case .custom(let year):
                return year
            }
        }
    }
}
