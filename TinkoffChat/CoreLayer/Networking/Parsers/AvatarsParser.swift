//
//  AvatarsParser.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AvatarAPIModel {

    let url: URL
}

class AvatarsParser: IParser {

    typealias Model = [AvatarAPIModel]

    func parse(data: Data) -> [AvatarAPIModel]? {
        let json = JSON(data)
        guard let avatars = json["hits"].array else { return nil }

        var avatarModels = [AvatarAPIModel]()
        for avatar in avatars {
            guard let url = avatar["previewURL"].url else { continue }
            avatarModels.append(AvatarAPIModel(url: url))
        }
        return avatarModels
    }
}
