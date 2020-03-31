//
//  KingfisherWrapper.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String?, placeholder: UIImage? = nil) {
        
        guard let urlString = urlString else {
            self.image = placeholder
            return
        }
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
