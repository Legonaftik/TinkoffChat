//
//  RequestsFactory.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

enum RequestsFactory {
    
    enum AvatarRequests {

        static func getAvatars() -> RequestConfig<AvatarsParser> {
            let request = GetAvatarsRequest(apiKey: "7121519-f35b7d8c483ba86df63a4d2df")
            return RequestConfig<AvatarsParser>(request: request, parser: AvatarsParser())
        }
    }
}
