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

    func displayError(with text: String)
}

class CommunicationManager {

    weak var conversationListDelegate: CommunicationManagerDelegate?
    weak var singleConversationDelegate: CommunicationManagerDelegate?

    var chatHistories: [ChatHistory] = []
    private let multipeerCommunicator = MultipeerCommunicator()

    init() {
        multipeerCommunicator.delegate = self
    }

    fileprivate func updateDelegatesState() {
        DispatchQueue.main.async {
            self.conversationListDelegate?.reloadData()
            self.singleConversationDelegate?.reloadData()
        }
    }

    func sendMessage(in chatHistory: ChatHistory, with text: String, completion: ((Bool, Error?) -> ())?) {

        multipeerCommunicator.sendMessage(string: text, to: chatHistory.userID) { [unowned self] (success, error) in

            if success {
                // Type outgoing
                chatHistory.messages.append(Message(text: text, messageType: .outgoing))
                self.chatHistories.sort(by: ChatHistory.comparator)
            }
            DispatchQueue.main.async {
                completion?(success, error)
                if success {
                    self.singleConversationDelegate?.reloadData()
                }
            }
        }
    }
}

extension CommunicationManager: CommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {

        // Remove any other sessions with this user if they are left in the array
        for i in 0 ..< chatHistories.count {
            if chatHistories[i].userID == userID {
                chatHistories.remove(at: i)
            }
        }

        // Otherwise create a new record
        chatHistories.append(ChatHistory(userID: userID, userName: userName ?? "Unknown user"))
        chatHistories.sort(by: ChatHistory.comparator)
        updateDelegatesState()
    }

    func didLostUser(userID: String) {

        for i in 0 ..< chatHistories.count {
            if chatHistories[i].userID == userID {
                chatHistories.remove(at: i)
            }
        }

        updateDelegatesState()
        DispatchQueue.main.async {
            self.singleConversationDelegate?.displayError(with: "Lost connection with this user.")
        }
    }

    func failedToStartBrowsingForUsers(error: Error) {
        conversationListDelegate?.displayError(with: error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        conversationListDelegate?.displayError(with: error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {

        for chatHistory in chatHistories {
            if chatHistory.userID == fromUser {
                chatHistory.addNewMessage(Message(text: text, messageType: .incoming))
            }
        }

        updateDelegatesState()
    }
}
