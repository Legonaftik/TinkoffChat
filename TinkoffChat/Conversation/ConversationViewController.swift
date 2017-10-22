//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    var chatHistory: ChatHistory!
    var communicationManager: CommunicationManager!

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
            tableView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @IBAction func changedMessageText(_ sender: UITextField) {
        if let messageText = sender.text {
            sendButton.isEnabled = !messageText.isEmpty
        } else {
            sendButton.isEnabled = false
        }
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        communicationManager.sendMessage(in: chatHistory, with: inputTextField.text!) { [weak self] (success, error) in
            guard let strongSelf = self else { return }

            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatHistory.userName
        communicationManager.singleConversationDelegate = self
    }
}

extension ConversationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistory.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatHistory.messages[indexPath.row]

        let cellId = message.messageType == .incoming ?
            MessageTableViewCell.incomingMessageId :
            MessageTableViewCell.outgoingMessageId

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
        cell.messageTextLabel.text = message.text

        return cell
    }
}

extension ConversationViewController: CommunicationManagerDelegate {

    func reloadData() {
        tableView.reloadData()
    }

    func displayError(with text: String) {
        displayAlert(message: text)
    }
}
