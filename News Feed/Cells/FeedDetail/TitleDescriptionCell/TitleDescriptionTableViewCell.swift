//
//  TitleDescriptionTableViewCell.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import UIKit

class TitleDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataFor(title: String? = nil, description: String? = nil) {
        if let title = title {
            titleDescriptionLabel.text = title
            titleDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }else if let description = description {
            titleDescriptionLabel.text = description
            titleDescriptionLabel.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
}
