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

    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }

    override func main() {
        success = false
        if NSKeyedArchiver.archiveRootObject(Profile.shared, toFile: fileName) {
            success = true
        }
    }
}

class ReadOperation: Operation {

    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }

    override func main() {
        if let savedProfile = NSKeyedUnarchiver.unarchiveObject(withFile: fileName) as? Profile {
            Profile.shared = savedProfile
        }
    }
}

class OperationDataManager: DataManager {

    var queue: OperationQueue {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        return queue
    }

    func write(completion: @escaping (Bool) -> ()) {

        let writeOperation = WriteOperation(fileName: userInfoFileName)
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
                completion(Profile.shared)
            }
        }

        queue.addOperation(readOperation)
    }
}
