//
//  EmptyView.swift
//  News Feed
//
//  Created by Manish Tamta on 08/03/2022.
//

import UIKit
import Combine

class EmptyView: NibView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var retryButton: UIButton!
    
    var retryButtonTapped = PassthroughSubject<Void, Never>()
    
    func setUpData(emptyScreenTitle: String,
                   image: UIImage?) {
        titleLabel.text = emptyScreenTitle
        errorImageView.image = image
        errorImageView.isHidden = (image == nil)
    }

    @IBAction func retryButtonPressed(_ sender: UIButton) {
        self.retryButtonTapped.send()
    }
    
    func hideRetryButton() {
        errorImageView.isHidden = true
        retryButton.isHidden = true
    }
}
