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
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tableView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = name
    }

    // TODO: For all VCs
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension ConversationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
