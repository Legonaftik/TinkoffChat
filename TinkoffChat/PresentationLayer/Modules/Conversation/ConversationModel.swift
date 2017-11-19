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

    func sendMessage(with text: String, to userID: String, completion: (Bool, String?) -> ())
}

protocol IConversationModelDelegate: class {

    func didUpdate(chatHistories: [ChatHistory])
    func displayError(with text: String)
}

class ConversationModel: IConversationModel {

    weak var delegate: IConversationModelDelegate?

    private var conversationsService: IConversationsService

    init(conversationsService: IConversationsService) {
        self.conversationsService = conversationsService
        self.conversationsService.singleConversationDelegate = self
    }

    func sendMessage(with text: String, to userID: String, completion: (Bool, String?) -> ()) {
        conversationsService.sendMessage(with: text, to: userID) { (success, errorMessage) in
            // TODO: Implement
        }
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
