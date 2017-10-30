//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 08/10/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    static let incomingMessageId = "incomingMessage"
    static let outgoingMessageId = "outgoingMessage"

    @IBOutlet weak var messageTextLabel: UILabel!
}
