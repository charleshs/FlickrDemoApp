//
//  PhotoInterface.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/4/1.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

protocol PhotoInterface {
    
    var id: String { get }
    
    var secret: String { get }
    
    var server: String { get }
    
    var farm: Int { get }
    
    var title: String { get }
}

extension PhotoInterface {
    
    var urlString: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}
