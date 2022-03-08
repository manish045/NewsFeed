//
//  NewsFeedTableViewCell.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsHeadlineLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model: FeedData! {
        didSet {
            newsImageView.image = nil
            newsHeadlineLabel.text = model.title ?? ""
            newsDescriptionLabel.text = model.datumDescription ?? ""
            if let date = model.publishedAt {
                newsDateLabel.text = date.getFormattedDate(format: "hh:mm")
            }
            let placeHolderImage = UIImage(systemName: "newspaper")!
            self.newsImageView.downloadImage(url: model.imageURL, placeHolderImage: placeHolderImage)
            self.layoutIfNeeded()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
