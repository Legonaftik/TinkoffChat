//
//  BorderedImageView.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 28/09/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
