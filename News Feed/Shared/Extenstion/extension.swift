//
//  extension.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import Foundation
import UIKit
import SDWebImage
import RealmSwift

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension UIImageView {
    func downloadImage(url: URL?, placeHolderImage: UIImage?) {
        SDWebImageManager.shared.loadImage(with: url, options: .avoidAutoSetImage, progress: .none) { [weak self] image, _, error, _, _, _ in
            guard let self = self else { return }
            if image == nil {
                self.image = placeHolderImage
            }else{
                self.image = image
            }
        }
    }
}

extension List {
    func toArray<T>() -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

extension Array {
    func toRealmList<T: Object>() -> List<T> {
        let array = List<T>()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
