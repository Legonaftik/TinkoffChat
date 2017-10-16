//
//  Profile.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class Profile: NSObject, NSCoding {

    static var shared = Profile()
    override init() {
        name = "Vladimir Pavlov"
        info = "iOS developer in Techmas"
        avatar = #imageLiteral(resourceName: "placeholder-user")
    }

    enum Keys {
        static let name = "name"
        static let info = "info"
        static let avatar = "avatar"
    }

    var name: String
    var info: String
    var avatar: UIImage

    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name) as? String,
            let info = aDecoder.decodeObject(forKey: Keys.info) as? String,
            let avatar = aDecoder.decodeObject(forKey: Keys.avatar) as? UIImage else { return nil }

        self.name = name
        self.info = info
        self.avatar = avatar
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name)
        aCoder.encode(info, forKey: Keys.info)
        aCoder.encode(avatar, forKey: Keys.avatar)
    }
}
