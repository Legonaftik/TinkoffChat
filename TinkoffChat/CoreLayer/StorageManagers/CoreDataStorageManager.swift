//
//  CoreDataStorageManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStorageManager: IStorageManager {

    private var coreDataStack = CoreDataStack()

    private lazy var saveContext: NSManagedObjectContext = {
        guard let context = self.coreDataStack.saveContext else {
            fatalError("Save context is not available.")
        }
        return context
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        guard let context = self.coreDataStack.mainContext else {
            fatalError("Main context is not available.")
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
        mainContext.perform { [unowned self] in
            
            let appUser = AppUser.findOrInsertAppUser(in: self.mainContext)
            guard let name = appUser.name, let info = appUser.info,
                let avatarData = appUser.avatar, let avatar = UIImage(data: avatarData) else { return }
            let profile = Profile(name: name, info: info, avatar: avatar)
            completion(profile)
        }
    }

    func getChatHistories(completion: @escaping ([ChatHistory]) -> ()) {
        // TODO: Implement
        completion([])
    }

    func saveMessage(with text: String, to userID: String, completion: @escaping (Bool, String?) -> ()) {
        // TODO: Implement
        completion(false, "Couldn't save message in CoreData.")
    }
}
