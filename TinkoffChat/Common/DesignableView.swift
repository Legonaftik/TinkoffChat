//
//  DesignableView.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
