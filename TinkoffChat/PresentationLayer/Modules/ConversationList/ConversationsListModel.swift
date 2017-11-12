//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IConversationsListModel {

    weak var delegate: IConversationsListModelDelegate? {get set}
    var conversationsService: IConversationsService {get}
    var chatHistories: [ChatHistory] {get}
}

protocol IConversationsListModelDelegate: class {

    func didUpdateChatHistories()
    func displayError(with text: String)
}

class ConversationsListModel: IConversationsListModel {

    weak var delegate: IConversationsListModelDelegate?

    var chatHistories: [ChatHistory] = []

    var conversationsService: IConversationsService = ConversationvsService()

    init() {
        conversationsService.conversationsListDelegate = self
    }
}

extension ConversationsListModel: IConversationsServiceDelegate {

    func didUpdate(chatHistories: [ChatHistory]) {
        self.chatHistories = chatHistories
        delegate?.didUpdateChatHistories()
    }

    func displayError(with text: String) {
        delegate?.displayError(with: text)
    }
}
