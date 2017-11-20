//
//  IDataManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IStorageManager {

    func write(profile: Profile, completion: @escaping (_ success: Bool) -> ())
    func read(completion: @escaping (_ profile: Profile) -> ())
    func getChatHistories(completion: @escaping ([ChatHistory]) -> ())
    func saveMessage(with text: String, userID: String, type: MessageType, completion: @escaping (_ success: Bool, _ errorMessage: String?) -> ())
    func updateUserInfo(userID: String, userName: String?, online: Bool, completion: @escaping (_ success: Bool) -> ())
}
