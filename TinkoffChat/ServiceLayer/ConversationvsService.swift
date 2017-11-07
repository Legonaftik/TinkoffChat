//
//  MultipeerConnectivityService.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 31/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IConversationsService {

    func sendMessage(in chatHistory: ChatHistory, with text: String)
    weak var singleConversationDelegate: IConversationsServiceDelegate? {get set}
    weak var conversationsListDelegate: IConversationsServiceDelegate? {get set}
}

protocol IConversationsServiceDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

class ConversationvsService: IConversationsService {

    weak var singleConversationDelegate: IConversationsServiceDelegate?
    weak var conversationsListDelegate: IConversationsServiceDelegate?

    private var communicationManager: ICommunicationManager = CommunicationManager()

    func sendMessage(in chatHistory: ChatHistory, with text: String) {
        communicationManager.sendMessage(in: chatHistory, with: text)
    }
}

extension ConversationvsService: ICommunicationManagerDelegate {

    func didUpdate(chatHistories: [ChatHistory]) {
        singleConversationDelegate?.didUpdate(chatHistories: chatHistories)
        conversationsListDelegate?.didUpdate(chatHistories: chatHistories)
    }

    func displayError(with text: String) {
        singleConversationDelegate?.displayError(with: text)
        conversationsListDelegate?.displayError(with: text)
    }
}
