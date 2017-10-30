//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class WriteOperation: Operation {

    var success = false
    let profile: Profile

    let fileName: String
    init(fileName: String, profile: Profile) {
        self.fileName = fileName
        self.profile = profile
    }

    override func main() {
        success = false
        if NSKeyedArchiver.archiveRootObject(profile, toFile: fileName) {
            success = true
        }
    }
}

class ReadOperation: Operation {

    // Will return the default profile if couldn't read a new one from the file
    var profile = Profile()

    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }

    override func main() {
        if let savedProfile = NSKeyedUnarchiver.unarchiveObject(withFile: fileName) as? Profile {
            profile = savedProfile
        }
    }
}

class OperationDataManager: IDataManager {

    var queue: OperationQueue {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        return queue
    }

    func write(profile: Profile, completion: @escaping (Bool) -> ()) {

        let writeOperation = WriteOperation(fileName: userInfoFileName, profile: profile)
        writeOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(writeOperation.success)
            }
        }

        queue.addOperation(writeOperation)
    }

    func read(completion: @escaping (Profile) -> ()) {

        let readOperation = ReadOperation(fileName: userInfoFileName)
        readOperation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(readOperation.profile)
            }
        }

        queue.addOperation(readOperation)
    }
}
