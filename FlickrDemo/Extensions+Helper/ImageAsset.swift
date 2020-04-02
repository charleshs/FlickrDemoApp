//
//  ImageAsset.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
    case icon_heart_fill
    case icon_heart_stroke
    
    func image() -> UIImage? {
        
        return UIImage(named: self.rawValue)
    }
}
