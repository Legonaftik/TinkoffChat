//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/09/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    private var imagePicker = UIImagePickerController()

    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var editButton: DesignableButton!

    @IBAction func chooseAvatar() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let galeryAction = UIAlertAction(title: "Установить из галереи", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(galeryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Этот кусок кода вызовет ошибку, т.к. на данном этапе subviews контроллера (в т.ч. IBOutelet'ы) еще не проинициализированы
//        print("\(#function): \(editButton.frame)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function): \(editButton.frame)")
        imagePicker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // frame кнопки мог поменяться, т.к. на данный момент должны были отработать методы viewWill(Did)LayoutSubviews.
        // Увы, этого не произошло. Мистика.
        print("\(#function): \(editButton.frame)")
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = photo
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
