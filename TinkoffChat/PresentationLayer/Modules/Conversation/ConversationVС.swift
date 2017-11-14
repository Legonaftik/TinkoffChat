//
//  ConversationVС.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationVС: UIViewController {

    var chatHistory: ChatHistory!
    var model: IConversationModel!
    private var online = true

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
        sendButton.isEnabled = online && !messageText.isEmpty
    }


    @IBAction func sendMessage(_ sender: UIButton) {
        guard let messageText = inputTextField.text,
            !messageText.isEmpty else {
                displayAlert(message: "Не удалось отправить сообщение!")
                return
        }

        model.sendMessage(in: chatHistory, with: messageText)

        inputTextField.text = ""
        sendButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = chatHistory.userName
        model.delegate = self
        addObserversForKeyboardAppearance()
    }
}

extension ConversationVС: UITableViewDataSource {

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

extension ConversationVС: IConversationModelDelegate {

    func didUpdate(chatHistories: [ChatHistory]) {
        tableView.reloadData()
    }

    func displayError(with text: String) {
        displayAlert(message: text)
        sendButton.isEnabled = false
        online = false
    }
}
