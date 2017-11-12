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
            fatalError("Save context is not available.")
        }
        return context
    }()

    func write(profile: Profile, completion: @escaping (Bool) -> ()) {
        saveContext.perform { [weak self] in
            guard let strongSelf = self else { return }

            let savedAppUser = AppUser.findOrInsertAppUser(in: strongSelf.saveContext)
            savedAppUser.name = profile.name
            savedAppUser.info = profile.info
            savedAppUser.avatar = UIImagePNGRepresentation(profile.avatar)

            strongSelf.coreDataStack.performSave(context: strongSelf.saveContext) {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }

    func read(completion: @escaping (Profile) -> ()) {
        let appUser = AppUser.findOrInsertAppUser(in: saveContext)
        let profile = Profile(name: appUser.name!, info: appUser.info!, avatar: UIImage(data: appUser.avatar!)!)
        // This save is neccessary for the first launch (when there's no saved profile yet)
        coreDataStack.performSave(context: saveContext) {
            DispatchQueue.main.async {
                completion(profile)
            }
        }
    }
}
