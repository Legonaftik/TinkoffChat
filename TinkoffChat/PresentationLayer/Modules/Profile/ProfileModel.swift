//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 28/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

struct ProfileViewModel {

    let avatar: UIImage
    let name: String
    let info: String

    init(profile: Profile) {
        self.avatar = profile.avatar
        self.name = profile.name
        self.info = profile.info
    }

    init(avatar: UIImage, name: String, info: String) {
        self.avatar = avatar
        self.name = name
        self.info = info
    }
}

protocol IProfileModel {

    weak var delegate: IProfileModelDelegate? {get set}
    func getProfile()
    func saveProfile(avatar: UIImage?, name: String?, info: String?)
}

protocol IProfileModelDelegate: class {

    func setup(profileViewModel: ProfileViewModel)
    func didFinishSaving(success: Bool)
}

class ProfileModel: IProfileModel {

    weak var delegate: IProfileModelDelegate?

    private let profileService: IProfileService = ProfileService()

    func getProfile() {
        profileService.getProfile { [weak self] profile in
            let profileViewModel = ProfileViewModel(profile: profile)
            self?.delegate?.setup(profileViewModel: profileViewModel)
        }
    }

    func saveProfile(avatar: UIImage?, name: String?, info: String?) {
        guard let name = name, let info = info, let avatar = avatar else {
            self.delegate?.didFinishSaving(success: false)
            return
        }

        let profile = Profile(name: name, info: info, avatar: avatar)
        profileService.saveProfile(profile) { [weak self] success in
            self?.delegate?.didFinishSaving(success: success)
        }
    }
}
