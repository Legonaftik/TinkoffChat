//
//  UIImageView+Extensions.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 21/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

extension UIImageView {

    func downloadImage(from url: URL) {
        self.image = #imageLiteral(resourceName: "placeholder-user")
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let imageData = try Data(contentsOf: url)
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.image = image ?? #imageLiteral(resourceName: "placeholder-user")
                }
            } catch {
                self.image = #imageLiteral(resourceName: "placeholder-user")
            }
        }
    }
}
