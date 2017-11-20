//
//  ConversationVС.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationVС: UIViewController {

    var model: ConversationModel!

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
            tableView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @IBAction func didChangeMessageText(_ sender: UITextField) {
        guard let messageText = sender.text else {
            sendButton.isEnabled = false
            return
        }
        sendButton.isEnabled = model.chatHistory.online && !messageText.isEmpty
    }


    @IBAction func sendMessage(_ sender: UIButton) {
        guard let messageText = inputTextField.text,
            !messageText.isEmpty else {
                displayAlert(message: "Invalid message.")
                return
        }

        model.sendMessage(with: messageText, to: model.chatHistory.userID) { [weak self] (success, errorMessage) in
            if success {
                self?.tableView.reloadData()
            } else {
                self?.displayAlert(message: errorMessage ?? "Couldn't send the message.")
            }
        }

        inputTextField.text = ""
        sendButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = model.chatHistory.userName
        model.delegate = self
        addObserversForKeyboardAppearance()
    }
}

extension ConversationVС: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.chatHistory.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = model.chatHistory.messages[indexPath.row]

        let cellId = message.messageType == .incoming ?
            MessageTableViewCell.incomingMessageId :
            MessageTableViewCell.outgoingMessageId

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? MessageTableViewCell else {
            fatalError("Wrong cell was dequeued.")
        }
        cell.messageTextLabel.text = message.text

        return cell
    }
}

extension ConversationVС: ConversationModelDelegate {

    func didReceiveMessage(with text: String, from userID: String) {
        if userID == model.chatHistory.userID {
            tableView.reloadData()
        }
    }

    func didDisconnect(peerID: String) {
        if peerID == model.chatHistory.userID {
            sendButton.isEnabled = false
            
            dismiss(animated: true, completion: nil)
            displayAlert(message: "Lost connection with \(model.chatHistory.userName).")
        }
    }

    func didReconnect(peerID: String) {
        if peerID == model.chatHistory.userID {
            sendButton.isEnabled = !(inputTextField.text?.isEmpty ?? true)

            dismiss(animated: true, completion: nil)
            displayAlert(message: "\(model.chatHistory.userName) is online again.")
        }
    }

    func displayError(with text: String) {
        displayAlert(message: text)
    }
}
