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

    private var model = DownloadAvatarModel()

    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private let itemsPerRow: CGFloat = 3

    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    private var loadingVC = LoadingVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self

        add(loadingVC)
        model.getAvatars()
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.avatars.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Dequeued a wrong cell.")
        }
        let avatarURL = model.avatars[indexPath.row].url

        cell.imageURL = avatarURL

        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell else {
            fatalError("Unexpected cell type.")
        }

        guard let avatar = cell.imageView.image else {
            fatalError("Photo cell must contain some image")
        }

        delegate?.didPickAvatar(avatar)
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
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

// MARK: - DownloadAvatarModelDelegate
extension DownloadAvatarCollectionVC: DownloadAvatarModelDelegate {

    func didReceiveError(with message: String) {
        loadingVC.remove()
        displayAlert(message: message)
    }

    func didGetAvatars() {
        loadingVC.remove()
        collectionView?.reloadData()
    }
}
