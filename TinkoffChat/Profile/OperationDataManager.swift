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

    static let shared = OperationDataManager()
    private init() {}

    var queue: OperationQueue {
        let queue = OperationQueue()
        queue.qualityOfService = .userInitiated
        return queue
    }

    func write(completion: @escaping (Bool) -> ()) {

        let saveOp = WriteOperation(fileName: userInfoFileName)
        saveOp.completionBlock = {
            OperationQueue.main.addOperation {
                completion(saveOp.success)
            }
        }

        queue.addOperation(saveOp)
    }

    func read(completion: @escaping (Profile) -> ()) {

        let restoreOp = ReadOperation(fileName: userInfoFileName)
        restoreOp.completionBlock = {
            OperationQueue.main.addOperation {
                completion(Profile.shared)
            }
        }

        queue.addOperation(restoreOp)
    }
}
