//
//  Extensions.swift
//  Listener
//
//  Created by Nehal Patel on 10/31/19.
//

import Foundation

extension String {
    /// The `String` without whitespaces or newlines on either side.
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Collection {
    /// A `Boolean` value indicating whether the collection has values.
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
