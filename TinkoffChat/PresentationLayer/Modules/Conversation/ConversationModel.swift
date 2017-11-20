//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 31/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol ConversationModelDelegate: class {

    func didReceiveMessage(with text: String, from userID: String)
    func displayError(with text: String)
    func didDisconnect(peerID: String)
    func didReconnect(peerID: String)
}

class ConversationModel {

    weak var delegate: ConversationModelDelegate?

    var chatHistory: ChatHistory

    private var conversationsService: IConversationsService

    init(chatHistory: ChatHistory, conversationsService: IConversationsService) {
        self.chatHistory = chatHistory

        self.conversationsService = conversationsService
        self.conversationsService.singleConversationDelegate = self
    }

    func sendMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ()) {
        conversationsService.sendMessage(with: text, to: userID, completion: completion)
    }
}

extension ConversationModel: IConversationsServiceSingleConversationDelegate {
    
    func didReceiveMessage(with text: String, from userID: String) {
        delegate?.didReceiveMessage(with: text, from: userID)
    }

    func didDisconnect(peerID: String) {
        delegate?.didDisconnect(peerID: peerID)
    }

    func didReconnect(peerID: String) {
        delegate?.didReconnect(peerID: peerID)
    }

    func displayError(with text: String) {
        delegate?.displayError(with: text)
    }
}
