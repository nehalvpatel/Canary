//
//  main.swift
//  Listener
//
//  Created by Nehal Patel on 10/24/19.
//  Copyright © 2019 Nehal Patel. All rights reserved.
//

import Foundation
import Combine

//let callPublisher = PassthroughSubject<Call, Error>()
//let publisher = callPublisher.eraseToAnyPublisher()
//
//
//let callSub = publisher
//    .print("test")
//    .receive(on: RunLoop.main)
//    .sink(receiveCompletion: { completion in
//        switch completion {
//        case .finished:
//            break
//        case .failure(let error):
//            print(error)
//            break
//        }
//    }, receiveValue: { call in
//        print(call)
//})
//let callSubscriber = AnyCancellable(callSub)
//

Listener.parseArguments() { configFilePath in
    do {
        let connection = try Listener(configFilePath: configFilePath)
        try connection.startListening()
    } catch {
        Listener.handleError(error)
    }
}
