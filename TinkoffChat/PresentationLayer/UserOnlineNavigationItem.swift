//
//  UserOnlineNavigationItem.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 27/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class UserOnlineNavigationItem: UINavigationItem {

    private let animationDuration = 1.0

    private lazy var offlineLabel: UILabel = {
        guard let label = self.titleView?.subviews.first as? UILabel else {
            fatalError("Title view is not set up in storyboard.")
        }
        return label
    }()

    private lazy var onlineLabel: UILabel = {
        guard let label = self.titleView?.subviews.last as? UILabel else {
            fatalError("Title view is not set up in storyboard.")
        }
        return label
    }()

    func setup(username: String, online: Bool) {
        offlineLabel.text = username
        onlineLabel.text = username

        onlineLabel.alpha = online ? 1.0 : 0.0
        offlineLabel.alpha = online ? 0.0 : 1.0
    }

    func updateUserStatus(online: Bool) {

        UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0, options: [], animations: {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.onlineLabel.alpha = online ? 1.0 : 0.0
                self.offlineLabel.alpha = online ? 0.0 : 1.0
            })

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
                self.offlineLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.onlineLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })

            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.offlineLabel.transform = .identity
                self.onlineLabel.transform = .identity
            })
        }, completion: nil)
    }
}
