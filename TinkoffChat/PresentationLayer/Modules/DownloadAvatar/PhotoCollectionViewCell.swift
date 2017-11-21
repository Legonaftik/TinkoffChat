//
//  PhotoCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    static let identifier = "photoCell"
    
    @IBOutlet weak var imageView: UIImageView!

    var imageURL: URL? {
        didSet {
            downloadImage()
        }
    }

    func downloadImage() {
        imageView.image = #imageLiteral(resourceName: "placeholder-user")

        guard let url = imageURL else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageData = try? Data(contentsOf: url),
                let image = UIImage(data: imageData) else { return }

            DispatchQueue.main.async {
                // Prevents from showing wrong images
                // (e.g. when the previous image for this cell was downloaded after the current image)
                if url == self.imageURL {
                    self.imageView.image = image
                }
            }
        }
    }
}
