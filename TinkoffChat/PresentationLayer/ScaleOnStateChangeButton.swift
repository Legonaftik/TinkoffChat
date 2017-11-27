//
//  ScaleOnStateChangeButton.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 27/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ScaleOnStateChangeButton: UIButton {

    private let animationDuration = 0.5
    private let enabledButtonColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
    private let disabledButtonColor = UIColor.lightGray

    override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                animateStatusChange()
            }
        }
    }

    private func animateStatusChange() {
        UIView.animate(withDuration: animationDuration/2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { _ in
            UIView.animate(withDuration: self.animationDuration/2, animations: {
                self.transform = .identity
            })
        })

        UIView.transition(with: self, duration: animationDuration, options: [], animations: {
            self.tintColor = self.isEnabled ? self.enabledButtonColor : self.disabledButtonColor
        }, completion: nil)
    }
}
