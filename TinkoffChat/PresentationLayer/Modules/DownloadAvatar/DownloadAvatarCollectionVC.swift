//
//  DownloadAvatarCollectionVC.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

protocol DownloadAvatarCollectionVCDelegate: class {

    func didPickAvatar(_ avatar: UIImage)
}

class DownloadAvatarCollectionVC: UICollectionViewController {

    weak var delegate: DownloadAvatarCollectionVCDelegate?

    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3

    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let requestSender = RequestSender()
        let requestConfig = RequestsFactory.AvatarRequests.getAvatars()
        requestSender.send(config: requestConfig) { [weak self] result in
            switch result {
            case .Success(let value):
                print(value)
            case .Fail(let errorMessage):
                self?.displayAlert(message: errorMessage)
            }
        }
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Dequeued a wrong cell.")
        }

        cell.imageView.image = #imageLiteral(resourceName: "placeholder-user")
        return cell
    }

    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPickAvatar(#imageLiteral(resourceName: "placeholder-user"))
        
        dismiss(animated: true, completion: nil)
    }
}

extension DownloadAvatarCollectionVC : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
