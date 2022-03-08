//
//    UITableView+Extension.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit

public extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(ofType cellType: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: "\(cellType)") as! T
    }
    
    func registerNibCell<T: UITableViewCell>(ofType cellType: T.Type) {
        let nib = UINib(nibName: "\(cellType)", bundle: nil)
        register(nib, forCellReuseIdentifier: "\(cellType)")
    }
}
