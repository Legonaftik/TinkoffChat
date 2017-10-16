//
//  GCDStorage.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import Foundation
import UIKit

class GCDStorage: DataStorage {

    static let shared = GCDStorage()
    private init() {}

    func write(completion: @escaping (_ success: Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {

            if NSKeyedArchiver.archiveRootObject(Profile.shared, toFile: self.userInfoFileName) {
                DispatchQueue.main.async {
                    // Testing wrong case
                    completion(false)
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
                    Profile.shared = storedProfile
                }
            DispatchQueue.main.async {
                completion(Profile.shared)
            }
        }
    }
}
