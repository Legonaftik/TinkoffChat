//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit
import CoreData

class StorageManager: IDataManager {

    var coreDataStack = CoreDataStack()
    lazy var saveContext: NSManagedObjectContext = {
        guard let context = self.coreDataStack.saveContext else {
            fatalError("Save context is not available")
        }
        return context
    }()

    func write(profile: Profile, completion: @escaping (Bool) -> ()) {
        coreDataStack.performSave(context: saveContext) {
            completion(true)
        }
    }

    func read(completion: @escaping (Profile) -> ()) {
        guard let appUser = AppUser.findOrInsertAppUser(in: saveContext) else {
            fatalError("Couldn't neither find nor create AppUser!")
        }
        let profile = Profile(name: appUser.name!, info: appUser.info!, avatar: UIImage(data: appUser.avatar!)!)
        completion(profile)
    }
}
