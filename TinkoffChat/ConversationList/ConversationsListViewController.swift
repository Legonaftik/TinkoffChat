//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 07/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    @IBOutlet var viewModel: ConversationListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ConversationsListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationTableViewCell

        // Filling the cell
        // Name
        cell.nameLabel.text = "Name:\(indexPath.section)\(indexPath.row)"
        // Message
        let message: String? = (indexPath.row % 2 == 0) ? "There is some message!!!" : nil
        if message == nil {
            cell.messageLabel.font = UIFont.italicSystemFont(ofSize: 14)
            cell.messageLabel.text = "No message yet"
        } else {
            cell.messageLabel.font = UIFont.systemFont(ofSize: 17)
            cell.messageLabel.text = message
        }
        // Date
        let date = (indexPath.row % 3 == 0) ? Date() : Date(timeIntervalSince1970: 100500)
        let dateFormatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM"
        }
        cell.dateLabel.text = dateFormatter.string(from: date)
        // Online
        let online = indexPath.section == 0
        cell.backgroundColor = online ? .yellow : .white
        // Unread messages
        let hasUnreadMessages = indexPath.row % 5 == 0
        cell.messageLabel.font = hasUnreadMessages ? UIFont.boldSystemFont(ofSize: 18) : UIFont.systemFont(ofSize: 17)

        return cell
    }

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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
