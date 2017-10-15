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

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gcdButton: DesignableButton!
    @IBOutlet weak var operationButton: DesignableButton!

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

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveUsingGCD() {
        DispatchQueue.global(qos: .userInitiated).async {

            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.gcdButton.isEnabled = false
                self.operationButton.isEnabled = false
            }

            let text = "some text" //just a text
            if let fileDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                let fileURL = fileDirectory.appendingPathComponent("file.txt")

                do {
                    try text.write(to: fileURL, atomically: false, encoding: .utf8)

                    DispatchQueue.main.async {
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        self.displayAlert(title: "Данные сохранены", message: nil, firstAction: okAction)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { [unowned self] _ in
                            self.saveUsingGCD()
                        })
                        self.displayAlert(title: "Ошибка", message: "Не удалось сохранить данные", firstAction: okAction, secondAction: retryAction)
                    }
                }
            }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.gcdButton.isEnabled = true
                self.operationButton.isEnabled = true
            }
        }
    }

    @IBAction func saveUsingOperation() {
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        addObserversForKeyboardAppearance()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
