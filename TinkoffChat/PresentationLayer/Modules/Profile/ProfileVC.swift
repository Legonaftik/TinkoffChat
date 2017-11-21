//
//  ProfileVC.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/09/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    private let downloadAvatarCollectionVCSegueID = "toDownloadAvatarCollectionVC"

    private var imagePicker = UIImagePickerController()
    private var model: IProfileModel = ProfileModel()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var avatarImageView: DesignableImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: DesignableButton!

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

        let downloadAction = UIAlertAction(title: "Download", style: .default) { [unowned self] _ in
            self.performSegue(withIdentifier: self.downloadAvatarCollectionVCSegueID, sender: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(galeryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(downloadAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveProfile() {
        saveButton.isEnabled = false
        activityIndicator.startAnimating()

        model.saveProfile(avatar: avatarImageView.image, name: nameTextField.text, info: infoTextField.text)
    }

    @IBAction func changedTextFieldText() {
        updateSaveButtonAvailability()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        model.getProfile()
        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        addObserversForKeyboardAppearance()
    }

    private func updateSaveButtonAvailability() {
        saveButton.isEnabled = model.profileDidChange(
            avatar: avatarImageView.image, name: nameTextField.text, info: infoTextField.text)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == downloadAvatarCollectionVCSegueID {
            guard let navigationVC = segue.destination as? UINavigationController,
                let downloadAvatarCollectionVC = navigationVC.topViewController as? DownloadAvatarCollectionVC else { return }

            downloadAvatarCollectionVC.delegate = self
        }
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.image = image
            updateSaveButtonAvailability()
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileVC: IProfileModelDelegate {

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
                self.saveButton.isEnabled = true
            }
            let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
                self.saveProfile()
            }
            displayAlert(title: "Error", message: "Couldn't save profile.", firstAction: okAction, secondAction: retryAction)
        }
    }
}

extension ProfileVC: DownloadAvatarCollectionVCDelegate {

    func didPickAvatar(_ avatar: UIImage) {
        avatarImageView.image = avatar
        updateSaveButtonAvailability()
    }
}
