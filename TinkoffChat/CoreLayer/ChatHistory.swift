//
//  ChatHistory.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class ChatHistory {

    var online: Bool
    let userID: String
    var userName: String
    var messages: [MessageTemp] = []

    var lastMessageDate: Date? {
        // TODO: Implement
        return Date()
    }

    init(userID: String, userName: String, online: Bool) {
        self.userID = userID
        self.userName = userName
        self.online = online
    }

    func addNewMessage(_ message: MessageTemp) {
        messages.append(message)
    }

    static func comparator(_ first: ChatHistory, _ second: ChatHistory) -> Bool {
        if first.lastMessageDate == nil && second.lastMessageDate == nil {
            return first.userName.lowercased() < second.userName.lowercased()
        }
        guard let date1 = first.lastMessageDate else {
            return false
        }
        guard let date2 = second.lastMessageDate else {
            return true
        }
        if date1 != date2 {
            return date1.compare(date2).rawValue == 1 ? true : false
        } else {
            return first.userName.lowercased() < second.userName.lowercased()
        }
    }
}
