//
//  CategoryCell.swift
//  ShortMemo
//
//  Created by Ilya Kokorin on 23.03.2022.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet var categoryBubble: UIView!
    @IBOutlet var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBubble.layer.cornerRadius = categoryBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
