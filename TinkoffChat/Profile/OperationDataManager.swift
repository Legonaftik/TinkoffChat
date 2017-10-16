//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 16/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class WriteOperation: AsyncOperation {

    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }

    override func main() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing

            var success = false
            if NSKeyedArchiver.archiveRootObject(Profile.shared, toFile: fileName) {
                success = true
            }
            OperationQueue.main.addOperation {
                NotificationCenter.default.post(name: .operationWrite, object: nil, userInfo: ["success": success])
            }
            state = .finished
        }
    }
}

class ReadOperation: AsyncOperation {

    let fileName: String
    init(fileName: String) {
        self.fileName = fileName
    }

    override func main() {
        if isCancelled {
            state = .finished
        } else {
            state = .executing

            if let savedProfile = NSKeyedUnarchiver.unarchiveObject(withFile: fileName) as? Profile {
                Profile.shared = savedProfile
                OperationQueue.main.addOperation {
                    NotificationCenter.default.post(name: .operationRead, object: nil)
                }
            }
            state = .finished
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
        queue.addOperation(saveOp)
        completion(true)
    }

    func read(completion: @escaping (Profile) -> ()) {
        let restoreOp = ReadOperation(fileName: userInfoFileName)
        queue.addOperation(restoreOp)
        completion(Profile.shared)
    }
}
