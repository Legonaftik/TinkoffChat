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
    private var profile = Profile() {
        didSet {
            updateUI()
        }
    }

    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return url!.appendingPathComponent("UserInfo").path
    }

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

    private func updateLocalUserInfo() {
        guard let avatar = self.avatarImageView.image,
            let name = self.nameTextField.text,
            let info = self.infoTextField.text else { return }

        self.profile.avatar = avatar
        self.profile.name = name
        self.profile.info = info
    }

    @IBAction func saveUsingGCD() {
        activityIndicator.startAnimating()
        gcdButton.isEnabled = false
        operationButton.isEnabled = false

        updateLocalUserInfo()

        DispatchQueue.global(qos: .userInitiated).async {
            if NSKeyedArchiver.archiveRootObject(self.profile, toFile: self.filePath) {
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    self.displayAlert(title: "Данные сохранены", message: nil, firstAction: okAction)
                }
            } else {
                DispatchQueue.main.async {
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    let retryAction = UIAlertAction(title: "Повторить", style: .default, handler: { [unowned self] _ in
                        self.saveUsingGCD()
                    })
                    self.displayAlert(title: "Ошибка", message: "Не удалось сохранить данные", firstAction: okAction, secondAction: retryAction)
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

        loadUserData()
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        addObserversForKeyboardAppearance()
    }

    private func profileInfoDidChange() -> Bool {
        return profile.avatar != avatarImageView.image || profile.name != nameTextField.text || profile.info != infoTextField.text
    }

    private func infoToSaveIsValid() -> Bool {
        return avatarImageView.image != nil && nameTextField.text != nil && infoTextField.text != nil
    }

    private func updateSaveButtonsAvailability() {
        if profileInfoDidChange(), infoToSaveIsValid() {
            gcdButton.isEnabled = true
            operationButton.isEnabled = true
        } else {
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
        }
    }

    private func updateUI() {
        DispatchQueue.main.async {
            self.avatarImageView.image = self.profile.avatar
            self.nameTextField.text = self.profile.name
            self.infoTextField.text = self.profile.info
        }
    }

    private func loadUserData() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let profile = NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath) as? Profile {
                self.profile = profile
            }
            self.updateUI()
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profile.avatar = image
            updateSaveButtonsAvailability()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateSaveButtonsAvailability()
        return true
    }
}
