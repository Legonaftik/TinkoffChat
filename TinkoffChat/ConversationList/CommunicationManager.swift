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
        print("didFoundUser; userID: \(userID), userName: \(userName ?? "Unknown")")
    }

    func didLostUser(userID: String) {
        print("didLostUser; userID: \(userID)")
    }

    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }

    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }

    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        print("didReceiveMessage; text: \(text)")
    }
}
