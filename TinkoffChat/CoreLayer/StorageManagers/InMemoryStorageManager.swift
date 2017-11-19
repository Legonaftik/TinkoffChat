//
//  InMemoryStorageManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 18/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

class InMemoryStorageManager: IStorageManager {

    private var conversations = [ChatHistory(userID: "-1", userName: "Fake name")]

    func getChatHistories(completion: @escaping ([ChatHistory]) -> ()) {
        completion(conversations)
    }

    func saveMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ()) {
        conversations[0].addNewMessage(MessageTemp(text: text, messageType: .outgoing))
        completion(true, nil)
    }


    func write(profile: Profile, completion: @escaping (_ success: Bool) -> ()) {
        completion(true)
        return
    }

    func read(completion: @escaping (_ profile: Profile) -> ()) {
        completion(Profile())
        return
    }
}
