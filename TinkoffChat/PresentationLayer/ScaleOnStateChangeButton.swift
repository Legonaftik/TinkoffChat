//
//  ScaleOnStateChangeButton.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 27/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ScaleOnStateChangeButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                UIView.animate(withDuration: 0.5, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }, completion: { _ in
                    self.transform = .identity
                })
            }
        }
    }
}
