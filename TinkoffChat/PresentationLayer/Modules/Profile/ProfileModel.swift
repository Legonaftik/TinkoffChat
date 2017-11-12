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
    func profileDidChange(avatar: UIImage?, name: String?, info: String?) -> Bool
}

protocol IProfileModelDelegate: class {

    func didGet(profileViewModel: ProfileViewModel)
    func didFinishSaving(success: Bool)
}

class ProfileModel: IProfileModel {

    weak var delegate: IProfileModelDelegate?

    private let profileService: IProfileService = ProfileService()
    // Will be used to compare with updated but not saved version of profile and decide
    // if the save button should be available
    private var lastSavedProfile: Profile?

    func getProfile() {
        profileService.getProfile { [weak self] profile in
            self?.lastSavedProfile = profile
            let profileViewModel = ProfileViewModel(profile: profile)
            self?.delegate?.didGet(profileViewModel: profileViewModel)
        }
    }

    func saveProfile(avatar: UIImage?, name: String?, info: String?) {
        guard let name = name, let info = info, let avatar = avatar else {
            self.delegate?.didFinishSaving(success: false)
            return
        }

        let profile = Profile(name: name, info: info, avatar: avatar)
        profileService.saveProfile(profile) { [weak self] success in
            self?.lastSavedProfile = profile
            self?.delegate?.didFinishSaving(success: success)
        }
    }

    func profileDidChange(avatar: UIImage?, name: String?, info: String?) -> Bool {
        // Lets save profile for the first time
        guard let lastSavedProfile = lastSavedProfile else {
            return true
        }

        // Won't let to save incorrect profile
        guard let name = name, let info = info, let avatar = avatar,
            !name.isEmpty, !info.isEmpty else {
                return false
        }

        return avatar != lastSavedProfile.avatar ||
            name != lastSavedProfile.name ||
            info != lastSavedProfile.info
    }
}
