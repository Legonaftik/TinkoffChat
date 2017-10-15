//
//  UIViewController+Extension.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 15/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

extension UIViewController {

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
