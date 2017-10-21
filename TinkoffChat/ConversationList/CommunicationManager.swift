//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class CommunicationManager: CommunicatorDelegate {

    func didFoundUser(userID: String, userName: String?) {

    }

    func didLostUser(userID: String) {

    }

    func failedToStartBrowsingForUsers(error: Error) {

    }

    func failedToStartAdvertising(error: Error) {

    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
}
