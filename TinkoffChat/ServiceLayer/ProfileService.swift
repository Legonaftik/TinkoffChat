//
//  ProfileService.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 28/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation

protocol IProfileService {

    func getProfile(completion: @escaping (Profile) -> ())
    func saveProfile(_ profile: Profile, completion: @escaping (_ success: Bool) -> ())
}

class ProfileService: IProfileService {

    private var dataManager: IDataManager = GCDDataManager()

    func getProfile(completion: @escaping (Profile) -> ()) {
        dataManager.read(completion: completion)
    }

    func saveProfile(_ profile: Profile, completion: @escaping (_ success: Bool) -> ()) {
        dataManager = GCDDataManager()
        dataManager.write(profile: profile, completion: completion)
    }
}
