//
//  ConversationvsService.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 05/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IConversationsService {

    weak var conversationsListDelegate: IConversationsServiceConversationsListDelegate? {get set}
    weak var singleConversationDelegate: IConversationsServiceSingleConversationDelegate? {get set}

    func sendMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ())
    func getConversationsList()
}

protocol IConversationsServiceConversationsListDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

protocol IConversationsServiceSingleConversationDelegate: class {

    func didReceiveMessage(with text: String, from userID: String)
    func displayError(with text: String)
    func didDisconnect(peerID: String)
    func didReconnect(peerID: String)
}

class ConversationvsService: IConversationsService {

    weak var conversationsListDelegate: IConversationsServiceConversationsListDelegate?
    weak var singleConversationDelegate: IConversationsServiceSingleConversationDelegate?

    private var communimationManager: ICommunicationManager = CommunicationManager()
    private let storageManager: IStorageManager = InMemoryStorageManager()

    init() {
        communimationManager.delegate = self
    }

    func sendMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ()) {
        communimationManager.sendMessage(with: text, to: userID) { [weak self] (success, errorMessage) in

            if success {
                self?.storageManager.saveMessage(with: text, userID: userID, type: .outgoing, completion: completion)
            } else {
                self?.singleConversationDelegate?.displayError(with: errorMessage ?? "Couldn't send message.")
            }
        }
    }

    func getConversationsList() {
        storageManager.getChatHistories { [weak self] chatHistories in
            self?.conversationsListDelegate?.didUpdate(chatHistories: chatHistories)
        }
    }
}

extension ConversationvsService: ICommunicationManagerDelegate {

    func didReceiveError(with message: String) {
        singleConversationDelegate?.displayError(with: message)
    }

    func didLoseUser(userID: String) {
        storageManager.updateUserInfo(userID: userID, userName: nil, online: false) { [weak self] _ in
            self?.getConversationsList()
            self?.singleConversationDelegate?.didDisconnect(peerID: userID)
        }
    }

    func didFindUser(userID: String, userName: String) {
        storageManager.updateUserInfo(userID: userID, userName: userName, online: true) { [weak self] _ in
            self?.getConversationsList()
            self?.singleConversationDelegate?.didReconnect(peerID: userID)
        }
    }

    func didReceiveMessage(with text: String, from userID: String) {
        storageManager.saveMessage(with: text, userID: userID, type: .incoming) { [weak self] (success, errorMessage) in
            if success {
                self?.getConversationsList()
                self?.singleConversationDelegate?.didReceiveMessage(with: text, from: userID)
            } else {
                self?.singleConversationDelegate?.displayError(with: errorMessage ?? "Error while saving a new message from \(userID)")
            }
        }
    }
}
