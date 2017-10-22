//
//  ChatHistory.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class ChatHistory {

    let userID: String
    let userName: String
    var messages: [Message] = []

    var lastMessageDate: Date? {
        // TODO: Implement
        return Date()
    }

    init(userID: String, userName: String) {
        self.userID = userID
        self.userName = userName
    }

    func addNewMessage(_ message: Message) {
        messages.append(message)
    }
}
