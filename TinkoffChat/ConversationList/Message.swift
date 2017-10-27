//
//  Message.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

enum MessageType: Int, Codable {

    case incoming
    case outgoing
}

struct Message: Codable {

    let eventType = "TextMessage"
    let messageId = generateMessageId()
    let text: String
    let date = Date()
    var messageType: MessageType


    init(text: String, messageType: MessageType) {
        self.text = text
        self.messageType = messageType
    }

    static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
