//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/09/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    enum SaveType {
        case gcd
        case operation
    }

    private var lastSaveType: SaveType = .gcd
    private var imagePicker = UIImagePickerController()
    private var model: IProfileModel = ProfileModel()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gcdButton: DesignableButton!
    @IBOutlet weak var operationButton: DesignableButton!

    @IBAction func chooseAvatar() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let galeryAction = UIAlertAction(title: "Choose from gallery", style: .default) { [unowned self] _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { [unowned self] _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(galeryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveUsingGCD() {
        lastSaveType = .gcd
        startSavingProfile()
    }

    @IBAction func saveUsingOperation() {
        lastSaveType = .operation
        startSavingProfile()
    }

    @IBAction func changedTextFieldText() {
        updateSaveButtonsAvailability()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        model.getProfile()
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        addObserversForKeyboardAppearance()
    }

    private func startSavingProfile() {
        gcdButton.isEnabled = false
        operationButton.isEnabled = false
        activityIndicator.startAnimating()

        saveProfile()
    }

    private func saveProfile() {
        switch lastSaveType {
        case .gcd:
            model.saveProfileUsingGCD(avatar: avatarImageView.image, name: nameTextField.text, info: infoTextField.text)
        case .operation:
            model.saveProfileUsingOperation(avatar: avatarImageView.image, name: nameTextField.text, info: infoTextField.text)
        }
    }

    private func updateSaveButtonsAvailability() {
        if model.profileDidChange(avatar: avatarImageView.image, name: nameTextField.text, info: infoTextField.text) {
            gcdButton.isEnabled = true
            operationButton.isEnabled = true
        } else {
            gcdButton.isEnabled = false
            operationButton.isEnabled = false
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

extension ProfileViewController: IProfileModelDelegate {

    func didGet(profileViewModel: ProfileViewModel) {
        nameTextField.text = profileViewModel.name
        infoTextField.text = profileViewModel.info
        avatarImageView.image = profileViewModel.avatar
    }

    func didFinishSaving(success: Bool) {
        activityIndicator.stopAnimating()

        if success {
            displayAlert(title: "Your profile is saved.")
        } else {
            let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
                // User should be able to try to save info again if something was wrong
                self.gcdButton.isEnabled = true
                self.operationButton.isEnabled = true
            }
            let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
                self.startSavingProfile()
            }
            displayAlert(title: "Error", message: "Couldn't save profile.", firstAction: okAction, secondAction: retryAction)
        }
    }
}
