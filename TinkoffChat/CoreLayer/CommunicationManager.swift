//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 05/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol ICommunicationManager {

    weak var conversationsListDelegate: ICommunicationManagerDelegate? {get set}
    weak var singleConversationDelegate: ICommunicationManagerDelegate? {get set}
    func sendMessage(in chatHistory: ChatHistory, with text: String)
}

protocol ICommunicationManagerDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

class CommunicationManager: ICommunicationManager {

    weak var conversationsListDelegate: ICommunicationManagerDelegate?
    weak var singleConversationDelegate: ICommunicationManagerDelegate?

    private var chatHistories: [ChatHistory] = []
    private var multipeerCommunicator: ICommunicator = MultipeerCommunicator()

    init() {
        multipeerCommunicator.delegate = self
    }

    func sendMessage(in chatHistory: ChatHistory, with text: String) {

        multipeerCommunicator.sendMessage(string: text, to: chatHistory.userID) { [unowned self] (success, error) in

            if success {
                // Type outgoing
                chatHistory.messages.append(Message(text: text, messageType: .outgoing))
                self.chatHistories.sort(by: ChatHistory.comparator)
            }
            DispatchQueue.main.async {
                if success {
                    self.singleConversationDelegate?.didUpdate(chatHistories: self.chatHistories)
                }
            }
        }
    }
}

extension CommunicationManager: ICommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {

        for i in 0 ..< chatHistories.count {
            if chatHistories[i].userID == userID {
                // Shouldn't add chat again
                return
            }
        }

        // Otherwise create a new record
        chatHistories.append(ChatHistory(userID: userID, userName: userName ?? "Unknown user"))
        chatHistories.sort(by: ChatHistory.comparator)

        DispatchQueue.main.async {
            self.conversationsListDelegate?.didUpdate(chatHistories: self.chatHistories)
        }
    }

    func didLostUser(userID: String) {

        // TODO: Move user to offline
        for i in 0 ..< chatHistories.count {
            if chatHistories[i].userID == userID {
                chatHistories.remove(at: i)
            }
        }

        DispatchQueue.main.async {
            self.conversationsListDelegate?.didUpdate(chatHistories: self.chatHistories)
            self.singleConversationDelegate?.displayError(with: "Lost connection with this user.")
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {
        DispatchQueue.main.async {
            self.conversationsListDelegate?.displayError(with: error.localizedDescription)
        }
    }

    func failedToStartAdvertising(error: Error) {
        DispatchQueue.main.async {
            self.conversationsListDelegate?.displayError(with: error.localizedDescription)
        }
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {

        for chatHistory in chatHistories {
            if chatHistory.userID == fromUser {
                chatHistory.addNewMessage(Message(text: text, messageType: .incoming))
            }
        }

        DispatchQueue.main.async {
            self.conversationsListDelegate?.didUpdate(chatHistories: self.chatHistories)
            self.singleConversationDelegate?.didUpdate(chatHistories: self.chatHistories)
        }
    }
}

