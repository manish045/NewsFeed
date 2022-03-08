//
//  NavigationTitleView.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit

class NavigationTitleView: NibView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func setText(_ text: String?) {
        titleLabel.text = text
    }
    
    func backgroundColor(_ color: UIColor) {
        self.view.backgroundColor = color
    }
    
}
