//
//  PhotosModel.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

struct PhotosSearchResponse: Codable {
    
    let photos: Photos
    let stat: String
}

struct Photos: Codable {
    
    let page: Int
    let pages: Int
    let perPage: Int
    let list: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perPage = "perpage"
        case list = "photo"
    }
}

struct Photo: Codable {
    
    let id: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    
    var urlString: String {
        return "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case title
    }
}
