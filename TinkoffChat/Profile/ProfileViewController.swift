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

    private let gcdDataManager = GCDDataManager()
    private let operationDataManager = OperationDataManager()

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
        saveUserInfo(using: gcdDataManager)
    }

    @IBAction func saveUsingOperation() {
        saveUserInfo(using: operationDataManager)
    }

    @IBAction func changedTextFieldText() {
        updateSaveButtonsAvailability()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserData(using: gcdDataManager)
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        addObserversForKeyboardAppearance()
    }

    private func updateLocalUserInfo() {
        guard let avatar = avatarImageView.image,
            let name = nameTextField.text,
            let info = infoTextField.text else { return }

        profile.avatar = avatar
        profile.name = name
        profile.info = info
    }

    private func saveUserInfo(using dataManager: DataManager) {
        updateLocalUserInfo()

        gcdButton.isEnabled = false
        operationButton.isEnabled = false

        activityIndicator.startAnimating()
        dataManager.write(profile: profile) { [weak self] success in
            guard let strongSelf = self else { return }

            strongSelf.activityIndicator.stopAnimating()

            if success {
                strongSelf.displayAlert(title: "Данные сохранены")
            } else {
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // User should be able to try to save info again if something was wrong
                    strongSelf.gcdButton.isEnabled = true
                    strongSelf.operationButton.isEnabled = true
                }
                let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
                    strongSelf.saveUserInfo(using: dataManager)
                }
                strongSelf.displayAlert(title: "Ошибка", message: "Не удалось сохранить данные", firstAction: okAction, secondAction: retryAction)
            }
        }
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

    private func profileInfoDidChange() -> Bool {
        return profile.avatar != avatarImageView.image || profile.name != nameTextField.text || profile.info != infoTextField.text
    }

    private func infoToSaveIsValid() -> Bool {
        return avatarImageView.image != nil && nameTextField.text != "" && infoTextField.text != ""
    }

    private func updateUI() {
        if isViewLoaded {
            avatarImageView.image = profile.avatar
            nameTextField.text = profile.name
            infoTextField.text = profile.info
        }
    }

    private func loadUserData(using dataManager: DataManager) {
        dataManager.read { [weak self] profile in
            guard let strongSelf = self else { return }

            strongSelf.profile = profile
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = image
            updateSaveButtonsAvailability()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
