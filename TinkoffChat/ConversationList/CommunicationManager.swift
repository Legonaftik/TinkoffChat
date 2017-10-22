//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol CommunicationManagerDelegate: class {

    func reloadData()
}

class CommunicationManager: CommunicatorDelegate {

    weak var conversationListDelegate: CommunicationManagerDelegate?

    var chatHistories: [ChatHistory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.conversationListDelegate?.reloadData()
            }
        }
    }
    private let multipeerCommunicator = MultipeerCommunicator()

    init() {
        multipeerCommunicator.delegate = self
    }

    func didFoundUser(userID: String, userName: String?) {
        print("didFoundUser; userID: \(userID), userName: \(userName ?? "Unknown")")

        for chatHistory in chatHistories {
            if chatHistory.userID == userID {
                // Then we got our user back online and shouldn't create a new record
                return
            }
        }
        // Otherwise create a new record
        chatHistories.append(ChatHistory(userID: userID, userName: userName ?? "Unknown user"))
    }

    func didLostUser(userID: String) {
        print("didLostUser; userID: \(userID)")

        for i in 0 ..< chatHistories.count {
            if chatHistories[i].userID == userID {
                chatHistories.remove(at: i)
                return
            }
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("didReceiveMessage; text: \(text)")

        for chatHistory in chatHistories {
            if chatHistory.userID == fromUser {
                chatHistory.addNewMessage(Message(text: text))
            }
        }
    }
}
