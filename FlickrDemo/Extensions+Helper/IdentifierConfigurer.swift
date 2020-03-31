//
//  IdentifierConfigurer.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
}
