//
//  UserOnlineNavigationItem.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 27/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class UserOnlineNavigationItem: UINavigationItem {

    private lazy var titleLabel: UILabel? = {
        return self.titleView?.subviews.first as? UILabel
    }()

    func setup(username: String, online: Bool) {
        titleLabel?.text = username
        titleLabel?.textColor = online ? .green : .black
    }

    func updateUserStatus(online: Bool) {
        UIView.animate(withDuration: 1.0, animations: {
            self.titleLabel?.textColor = online ? .green : .black
            self.titleLabel?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            self.titleLabel?.transform = .identity
        })
    }
}
