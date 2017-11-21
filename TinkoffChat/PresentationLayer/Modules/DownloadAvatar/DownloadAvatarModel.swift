//
//  DownloadAvatarModel.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol DownloadAvatarModelDelegate: class {

    func didReceiveError(with message: String)
    func didGetAvatars()
}

class DownloadAvatarModel {

    weak var delegate: DownloadAvatarModelDelegate?
    private let imagesService: IImagesService = ImagesService()

    var avatars = [AvatarAPIModel]()

    func getAvatars() {
        imagesService.getAvatars { [weak self] (avatarAPIModels, errorMessage) in
            if let avatarAPIModels = avatarAPIModels {
                self?.avatars = avatarAPIModels
                self?.delegate?.didGetAvatars()
            } else {
                self?.delegate?.didReceiveError(with: errorMessage ?? "Error while gettings avatars.")
            }
        }
    }
}
