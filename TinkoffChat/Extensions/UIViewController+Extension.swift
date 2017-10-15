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

    func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func handleKeyboardNotification(_ notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            view.frame.origin.y = isKeyboardShowing ? -(keyboardHeight) : 0.0
        }
    }

    func addObserversForKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
}
