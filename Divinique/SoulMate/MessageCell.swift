//
//  MessageCell.swift
//  Divinique
//
//  Created by LinjunCai on 7/6/2024.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let messageLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMessageLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMessageLabel() {
        contentView.addSubview(messageLabel)
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(with message: Message, isFromCurrentUser: Bool) {
        messageLabel.text = message.text
        messageLabel.textAlignment = isFromCurrentUser ? .right : .left
        messageLabel.backgroundColor = isFromCurrentUser ? UIColor.lightGray.withAlphaComponent(0.5) : UIColor.blue.withAlphaComponent(0.2)
    }
}
