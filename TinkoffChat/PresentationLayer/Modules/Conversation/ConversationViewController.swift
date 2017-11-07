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
    var model: IConversationModel!

    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
            tableView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        guard let messageText = inputTextField.text,
            !messageText.isEmpty else { return }

        model.sendMessage(in: chatHistory, with: inputTextField.text!)
        inputTextField.text = ""
        inputTextField.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatHistory.userName
        model.delegate = self
        addObserversForKeyboardAppearance()
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

extension ConversationViewController: IConversationModelDelegate {

    func didUpdate(chatHistories: [ChatHistory]) {
        tableView.reloadData()
    }

    func displayError(with text: String) {
        displayAlert(message: text)
        sendButton.isEnabled = false
    }
}