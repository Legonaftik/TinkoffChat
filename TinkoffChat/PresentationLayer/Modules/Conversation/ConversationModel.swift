//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 31/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IConversationModel {

    weak var delegate: IConversationModelDelegate? {get set}
    func sendMessage(in chatHistory: ChatHistory, with text: String)
}

protocol IConversationModelDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

class ConversationModel: IConversationModel {

    weak var delegate: IConversationModelDelegate?

    private let conversationsService: IConversationsService

    init(conversationsService: IConversationsService) {
        self.conversationsService = conversationsService
    }

    func sendMessage(in chatHistory: ChatHistory, with text: String) {
        conversationsService.sendMessage(in: chatHistory, with: text)
    }
}

extension ConversationModel: IConversationsServiceDelegate {
    
    func didUpdate(chatHistories: [ChatHistory]) {
        delegate?.didUpdate(chatHistories: chatHistories)
    }

    func displayError(with text: String) {
        delegate?.displayError(with: text)
    }
}
