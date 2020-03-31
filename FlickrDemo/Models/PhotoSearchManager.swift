//
//  FlickrAPIManager.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

enum QueryParam {
    case method(String)
    case format(String)
    case noJsonCallback(Int)
    case apiKey(String)
    case text(String)
    case perPage(Int)
    case page(Int)
    
    var key: String {
        switch self {
        case .method: return "method"
        case .format: return "format"
        case .noJsonCallback: return "nojsoncallback"
        case .apiKey: return "api_key"
        case .text: return "text"
        case .perPage: return "per_page"
        case .page: return "page"
        }
    }
    
    var value: String {
        switch self {
        case let .method(method):
            return method
        case let .format(format):
            return format
        case let .noJsonCallback(value):
            return String(value)
        case let .apiKey(apiKey):
            return apiKey
        case let .text(text):
            return text
        case let .perPage(perPage):
            return String(perPage)
        case let .page(page):
            return String(page)
        }
    }
}

struct PhotoSearchRequest: CSRequest {
    
    var urlString: String {
        return apiEndpoint + makeQueryString(params)
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var body: Data? {
        return nil
    }
    
    var params: [String: String] = [:]
    
    private let apiEndpoint: String = "https://www.flickr.com/services/rest/?"
    private let methodValue: String = "flickr.photos.search"
    private let formatValue: String = "json"
    private let noJsonCallbackValue: Int = 1
    
    init(queryParams: [QueryParam] = []) {
        var queryParams = queryParams
        queryParams.append(.method(methodValue))
        queryParams.append(.format(formatValue))
        queryParams.append(.noJsonCallback(noJsonCallbackValue))
        for param in queryParams {
            self.params[param.key] = param.value
        }
    }
}

protocol PhotoSearchable {
    
    func fetchPhotoList(completion: @escaping (Result<Photos, Error>) -> Void)
}

class PhotoSearchManager: PhotoSearchable {
    
    var apiKey: String {
        guard
            let path = Bundle.main.path(forResource: "Flickr", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let apiKey = dict["APIKey"] as? String
        else {
            return ""
        }
        return apiKey
    }
    
    private var searchText: String
    private var itemsPerPage: Int
    
    init(searchText: String, itemsPerPage: Int) {
        self.searchText = searchText
        self.itemsPerPage = itemsPerPage
    }
    
    func fetchPhotoList(completion: @escaping (Result<Photos, Error>) -> Void) {
        
        let photoSearchRequest = PhotoSearchRequest(queryParams: [
            .apiKey(apiKey),
            .text(searchText),
            .perPage(itemsPerPage)
        ])
        
        HTTPClient.shared.request(photoSearchRequest) { (result) in
            switch result {
            case let .success(data):
                do {
                    let response = try JSONDecoder().decode(PhotosSearchResponse.self, from: data)
                    completion(.success(response.photos))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
