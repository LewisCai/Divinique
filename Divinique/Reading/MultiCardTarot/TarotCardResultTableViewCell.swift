//
//  TarotCardResultTableViewCell.swift
//  Divinique
//
//  Created by LinjunCai on 16/5/2024.
//

import UIKit

class TarotCardResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tarotCardImage: UIImageView!
    
    @IBOutlet weak var tarotCardLabel: UILabel!
    
    @IBOutlet weak var tarotCardReading: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
