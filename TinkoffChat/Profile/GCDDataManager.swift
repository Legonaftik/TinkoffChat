//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class GCDDataManager: DataManager {

    // Will return the default profile if couldn't read a new one from the file
    var profile = Profile()

    func write(profile: Profile, completion: @escaping (_ success: Bool) -> ()) {

        DispatchQueue.global(qos: .userInitiated).async {

            if NSKeyedArchiver.archiveRootObject(profile, toFile: self.userInfoFileName) {
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }

    func read(completion: @escaping (_ profile: Profile) -> ()) {

        DispatchQueue.global(qos: .userInitiated).async {
            if let storedProfile = NSKeyedUnarchiver.unarchiveObject(withFile: self.userInfoFileName) as? Profile {
                    self.profile = storedProfile
                }
            DispatchQueue.main.async {
                completion(self.profile)
            }
        }
    }
}
