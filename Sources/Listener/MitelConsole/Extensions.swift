//
//  Extensions.swift
//  Listener
//
//  Created by Nehal Patel on 10/31/19.
//

import Foundation

extension String {
    var trimmed: String {
        get {
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}
