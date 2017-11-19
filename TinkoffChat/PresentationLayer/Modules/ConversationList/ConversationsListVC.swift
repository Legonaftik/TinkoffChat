//
//  ConversationsListVС.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationsListVC: UIViewController {

    private let conversationSegueId = "toConversation"

    private var model: IConversationsListModel = ConversationsListModel()
    fileprivate let dateFormatter = DateFormatter()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        model.getConversationsList()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == conversationSegueId {
            guard let conversationVC = segue.destination as? ConversationVС,
                let indexPath = tableView.indexPathForSelectedRow else { return }

            conversationVC.chatHistory = model.chatHistories[indexPath.row]
            conversationVC.model = ConversationModel(conversationsService: model.conversationsService)
        }
    }
}

extension ConversationsListVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "Offline"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.chatHistories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationTableViewCell
        let chatHistory = model.chatHistories[indexPath.row]
        configure(cell, using: chatHistory)
        return cell
    }

    private func configure(_ cell: ConversationTableViewCell, using chatHistory: ChatHistory) {

        cell.nameLabel.text = chatHistory.userName

        cell.messageLabel.text = chatHistory.messages.last?.text ?? "No messages yet"
        let message = chatHistory.messages.last?.text
        let noMessagesYet = message == nil
        if noMessagesYet {
            cell.messageLabel.text = "No message yet"
            cell.messageLabel.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 17)!
        } else {
            cell.messageLabel.text = message

            if let lastMessage = chatHistory.messages.last,
                lastMessage.messageType == .incoming {
                cell.messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            } else {
                cell.messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            }
        }

        if let date = chatHistory.lastMessageDate {
            if Calendar.current.isDateInToday(date) {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "dd MMM"
            }
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }

        cell.backgroundColor = UIColor.tinkoffYellow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ConversationsListVC: IConversationsListModelDelegate {
    
    func didUpdateChatHistories() {
        tableView.reloadData()
    }

    func displayError(with text: String) {
        displayAlert(message: text)
    }
}
