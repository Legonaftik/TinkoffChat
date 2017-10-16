//
//  DataManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol DataManager {
    func write(completion: @escaping (_ success: Bool) -> ())
    func read(completion: @escaping (_ profile: Profile) -> ())
}

extension DataManager {

    var userInfoFileName: String {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return url.appendingPathComponent("UserInfo").path
    }
}
