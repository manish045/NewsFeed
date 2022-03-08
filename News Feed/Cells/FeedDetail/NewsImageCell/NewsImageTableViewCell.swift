//
//  NewsImageTableViewCell.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import UIKit

class NewsImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var imageURL: URL? {
        didSet {
            newsImageView.downloadImage(url: imageURL,
                                        placeHolderImage: UIImage(systemName: "news"))
        }
    }
    
}
