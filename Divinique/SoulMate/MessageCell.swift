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
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        ])
    }
    
    func configure(with message: Message, isFromCurrentUser: Bool) {
        messageLabel.text = message.text
        if isFromCurrentUser {
            messageLabel.textAlignment = .right
            messageLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 10).isActive = true
        } else {
            messageLabel.textAlignment = .left
            messageLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10).isActive = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        NSLayoutConstraint.deactivate(messageLabel.constraints)
        setupMessageLabel()
    }
}
