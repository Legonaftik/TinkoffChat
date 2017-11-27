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

    private lazy var titleLabel: UILabel? = {
        return self.titleView?.subviews.first as? UILabel
    }()

    func setup(username: String, online: Bool) {
        titleLabel?.text = username
        titleLabel?.textColor = online ? .green : .black
    }

    func updateUserStatus(online: Bool) {
        titleLabel?.textColor = online ? .green : .black

        UIView.animate(withDuration: animationDuration/2, animations: {
            self.titleLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: self.animationDuration/2, animations: {
                self.titleLabel?.transform = .identity
            })
        })
    }
}
