//
//  HTTPClient.swift
//  FlickrDemo
//
//  Created by Charles Hsieh on 2020/3/31.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

enum HTTPClientError: Error {
    
    case invalidURL
    case clientError(Data)
    case serverError
    case unexpectedError
}

enum HTTPMethod: String {
    
    case GET
    case POST
}

protocol CSRequest {
    
    var urlString: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension CSRequest {
    
    func makeRequest() throws -> URLRequest {
        
        guard let url = URL(string: urlString) else {
            throw HTTPClientError.invalidURL
        }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.httpMethod = method.rawValue
        return request
    }
}

class HTTPClient {
    
    static let shared = HTTPClient()
    
    private let session: URLSession = {
        let session = URLSession(configuration: .default)
        session.delegateQueue.maxConcurrentOperationCount = 10
        return session
    }()
    
    @discardableResult
    func request(_ request: CSRequest,
                 completion: @escaping (Result<Data, HTTPClientError>) -> Void) -> URLSessionDataTask? {
        
        guard let request = try? request.makeRequest() else {
            completion(.failure(.invalidURL))
            return nil
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            guard
                error == nil, let data = data, let response = response as? HTTPURLResponse
            else {
                completion(.failure(.unexpectedError))
                return
            }
            switch response.statusCode {
            case 200 ..< 300:
                completion(.success(data))
            case 400 ..< 500:
                completion(.failure(.clientError(data)))
            case 500 ..< 600:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unexpectedError))
            }
        }
        task.resume()
        return task
    }
}
