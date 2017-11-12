//
//  AppUser.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit
import CoreData

extension AppUser {

    static func insertDefaultAppUser(in context: NSManagedObjectContext) -> AppUser {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser else {
            fatalError("Couldn't create AppUser entity.")
        }
        appUser.name = "Input your name"
        appUser.info = "Tell something about yourself"
        appUser.avatar = UIImagePNGRepresentation(#imageLiteral(resourceName: "placeholder-user"))

        return appUser
    }

    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            fatalError("Model is not available in context!")
        }

        let fetchRequest = AppUser.fetchRequestAppUser(model: model)
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                return foundUser
            }
        } catch {
            assert(false, "Failed to fetch AppUser: \(error)")
        }

        return AppUser.insertDefaultAppUser(in: context)
    }

    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser> {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            fatalError("No template with name \(templateName).")
        }
        return fetchRequest
    }
}
