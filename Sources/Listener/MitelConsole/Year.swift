//
//  Year.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

public enum Year {
    case current(Calendar)
    case custom(Int)
    
    func value() -> Int {
        switch self {
        case .current(let calendar):
            return calendar.component(.year, from: Date())
        case .custom(let year):
            return year
        }
    }
}
