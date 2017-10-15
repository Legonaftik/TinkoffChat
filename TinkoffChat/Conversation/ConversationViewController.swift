//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {

    var name: String!

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
            tableView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
    }
}

extension ConversationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Mock data
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Mock data

        // Choose the correct cell type
        let cellId = indexPath.row % 2 == 0 ?
            MessageTableViewCell.incomingMessageId :
            MessageTableViewCell.outgoingMessageId
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
        // Configure message text
        let messageText: String
        switch indexPath.row % 3 {
        case 0:
            messageText = "o"
        case 1:
            messageText = String(repeating: "o", count: 30)
        case 2:
            messageText = String(repeating: "o", count: 300)
        default:
            messageText = "Wrong message!"
        }
        cell.messageTextLabel.text = messageText

        return cell
    }
}
