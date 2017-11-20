//
//  InMemoryStorageManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 18/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class InMemoryStorageManager: IStorageManager {

    private var conversations = [ChatHistory(userID: "-1", userName: "Fake user", online: false)]

    func getChatHistories(completion: @escaping ([ChatHistory]) -> ()) {
        completion(conversations)
    }

    func saveMessage(with text: String, userID: String, type: MessageType, completion: @escaping (Bool, String?) -> ()) {
        for conversation in conversations {
            if conversation.userID == userID {
                conversation.addNewMessage(MessageTemp(text: text, messageType: type))
                completion(true, nil)
                return
            }
        }

        completion(false, "Can't save message. UserID is incorrect.")
    }

    func write(profile: Profile, completion: @escaping (_ success: Bool) -> ()) {
        completion(true)
        return
    }

    func read(completion: @escaping (_ profile: Profile) -> ()) {
        completion(Profile())
        return
    }

    func updateUserInfo(userID: String, userName: String?, online: Bool, completion: @escaping (_ success: Bool) -> ()) {
        // Already existing conversation
        for conversation in conversations {
            if conversation.userID == userID {
                if let newUserName = userName {
                    conversation.userName = newUserName
                }
                conversation.online = online

                completion(true)
                return
            }
        }
        // New conversation
        conversations.append(ChatHistory(userID: userID, userName: userName ?? "Unknown userName", online: online))
        completion(true)
    }
}
