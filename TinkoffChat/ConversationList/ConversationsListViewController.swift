//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    private let conversationSegueId = "toConversation"

    private let communicationManager = CommunicationManager()
    fileprivate let dateFormatter = DateFormatter()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        communicationManager.conversationListDelegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == conversationSegueId {
            guard let conversationVC = segue.destination as? ConversationViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let cell = tableView.cellForRow(at: indexPath) as? ConversationTableViewCell,
                let name = cell.nameLabel.text else { return }

            conversationVC.name = name
        }
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Mock data
        return communicationManager.chatHistories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationTableViewCell
        let chatHistory = communicationManager.chatHistories[indexPath.row]
        configure(cell, using: chatHistory)
        return cell
    }

    private func configure(_ cell: ConversationTableViewCell, using chatHistory: ChatHistory) {

        cell.nameLabel.text = chatHistory.userName

        cell.messageLabel.text = chatHistory.messages.last?.text ?? "No messages yet"
        let message = chatHistory.messages.last?.text
        if message == nil {
            cell.messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            cell.messageLabel.text = "No message yet"
        } else {
            cell.messageLabel.font = UIFont.systemFont(ofSize: 17)
            cell.messageLabel.text = message
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

extension ConversationsListViewController: CommunicationManagerDelegate {

    func reloadData() {
        tableView.reloadData()
    }
}
