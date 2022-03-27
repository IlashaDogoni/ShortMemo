//
//  ItemCell.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 23.03.2022.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet var messageBubble: UIView!
    @IBOutlet var label: UILabel!
    @IBOutlet var checkmarkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
        checkmarkImageView.layer.cornerRadius = 20
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
