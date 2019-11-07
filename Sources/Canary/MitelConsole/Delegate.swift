//
//  Delegate.swift
//  Canary
//
//  Created by Nehal Patel on 11/6/19.
//

import Foundation

protocol MitelConsoleDelegate: AnyObject {
    /// Hook for connection attempt events. Called right before the connection is opened.
    func mitelConsoleDidAttemptConnection(_ console: MitelConsole) -> Void
    
    /// Hook for successful connection events.
    func mitelConsoleDidEstablishConnection(_ console: MitelConsole) -> Void
    
    /// Hook for connection close events.
    func mitelConsoleDidCloseConnection(_ console: MitelConsole) -> Void
    
    /// Hook that is fired when a new line is read.
    func mitelConsole(_ console: MitelConsole, didReadLine line: String) -> Void
    
    /// Hook that is fired when a new `Call` is read.
    func mitelConsole(_ console: MitelConsole, didReadCall call: MitelConsole.Call) -> Void
}
