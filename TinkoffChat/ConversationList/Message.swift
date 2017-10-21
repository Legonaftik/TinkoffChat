//
//  Message.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

struct Message: Codable {

    let eventType = "TextMessage"
    let messageId = generateMessageId()
    let text: String

    init(text: String) {
        self.text = text
    }

    static func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT32_MAX))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
}
