//
//  String+dictionaryByMatching.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation

extension String {
    /// Found at https://stackoverflow.com/a/48309290
    
    public func dictionaryByMatching(regex regexString: String) -> [String: String]? {
        let string = NSString(string: self)
        guard let nameRegex = try? NSRegularExpression(pattern: "\\(\\?\\<(\\w+)\\>", options: []) else {return nil}
        let nameMatches = nameRegex.matches(in: regexString, options: [], range: NSMakeRange(0, regexString.count))
        let names = nameMatches.map { (textCheckingResult) -> String in
            return (regexString as NSString).substring(with: textCheckingResult.range(at: 1))
        }
        guard let regex = try? NSRegularExpression(pattern: regexString, options: []) else {return nil}
        let result = regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count))


        var dict = [String: String]()
        for name in names {
            if let range = result?.range(withName: name),
                range.location != NSNotFound
            {
                dict[name] = string.substring(with: range)
            }
        }
        return dict.count > 0 ? dict : nil
    }
}
