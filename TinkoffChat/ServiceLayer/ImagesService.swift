//
//  ImagesService.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IImagesService {

    func getAvatars(completion: @escaping ([AvatarAPIModel]?, String?) -> ())
}

class ImagesService: IImagesService {

    private let requestSender: IRequestSender = RequestSender()

    func getAvatars(completion: @escaping ([AvatarAPIModel]?, String?) -> ()) {
        let config = RequestsFactory.AvatarRequests.getAvatars()

        requestSender.send(config: config) { result in
            switch result {
            case .success(let avatars):
                completion(avatars, nil)
            case .fail(let errorMessage):
                completion(nil, errorMessage)
            }
        }
    }
}
