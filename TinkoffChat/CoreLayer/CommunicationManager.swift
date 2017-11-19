//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 18/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol ICommunicationManager {

    weak var delegate: ICommunicationManagerDelegate? {get set}
    
    func sendMessage(with text: String, to userID: String, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ())
}

protocol ICommunicationManagerDelegate: class {

    func didReceiveError(with message: String)
    func didLoseUser(userID: String)
    func didFindUser(userID: String, userName: String)
    func didReceiveMessage(with text: String, from userID: String)
}

class CommunicationManager: ICommunicationManager {

    var delegate: ICommunicationManagerDelegate?

    private var multipeerCommunicator: ICommunicator = MultipeerCommunicator()

    init() {
        multipeerCommunicator.delegate = self
    }

    func sendMessage(with text: String, to userID: String,  completion: @escaping (Bool, String?) -> ()) {

        multipeerCommunicator.sendMessage(with: text, to: userID) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    completion(success, error?.localizedDescription)
                }
            }
        }
    }
}

extension CommunicationManager: ICommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {
        delegate?.didLoseUser(userID: userID)
    }

    func didLostUser(userID: String) {
        delegate?.didLoseUser(userID: userID)
    }

    func failedToStartBrowsingForUsers(error: Error) {
        delegate?.didReceiveError(with: error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        delegate?.didReceiveError(with: error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didReceiveMessage(with: text, from: fromUser)
    }
}
