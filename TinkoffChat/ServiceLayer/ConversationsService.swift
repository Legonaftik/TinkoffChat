//
//  ConversationvsService.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 05/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IConversationsService {

    weak var conversationsListDelegate: IConversationsServiceDelegate? {get set}
    weak var singleConversationDelegate: IConversationsServiceDelegate? {get set}

    func sendMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ())
    func getConversationsList()
}

protocol IConversationsServiceDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

class ConversationvsService: IConversationsService {

    weak var conversationsListDelegate: IConversationsServiceDelegate?
    weak var singleConversationDelegate: IConversationsServiceDelegate?

    private var communimationManager: ICommunicationManager = CommunicationManager()
    private let storageManager: IStorageManager = InMemoryStorageManager()

    init() {
        communimationManager.delegate = self
    }

    func sendMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ()) {
        communimationManager.sendMessage(with: text, to: userID) { [weak self] (success, errorMessage) in

            if success {
                self?.storageManager.saveMessage(with: text, to: userID, completion: completion)
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
            self?.singleConversationDelegate?.displayError(with: "Lost connection with \(userID)")
        }
    }
    func didFindUser(userID: String, userName: String) {

        storageManager.updateUserInfo(userID: userID, userName: userName, online: true) { [weak self] _ in

            self?.getConversationsList()
        }
    }

    func didReceiveMessage(with text: String, from userID: String) {
        // TODO: Differentiate incoming and outcoming messages; update convVC
        storageManager.saveMessage(with: text, to: "self") { [weak self] (success, errorMessage) in
            if success {
                self?.getConversationsList()
            } else {
                self?.singleConversationDelegate?.displayError(with: errorMessage ?? "Error while saving a new message from \(userID)")
            }
        }
    }
}
