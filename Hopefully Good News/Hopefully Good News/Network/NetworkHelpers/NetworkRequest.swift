//
//  NetworkRequest.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation

public protocol NetworkRequest {
    associatedtype Response: Codable
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var queryItems: [String: Any?]? { get }
}

public extension NetworkRequest {
    
    var baseURL: String {
        Constants.baseURL
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var body: Encodable? {
        nil
    }
    
    var queryItems: [String: Any?]? {
        nil
    }
    
    private func buildURL() -> URL? {
        guard let url = URL(string: baseURL + path) else {
            preconditionFailure(NetworkError.invalidURL.localizedDescription)
        }
        
        return url
    }
    
    private func handleQueryItems() -> [URLQueryItem] {
        let apiKey = Constants.apiKey
        
        var urlQueryItems: [URLQueryItem] = []
        urlQueryItems.append(URLQueryItem(name: "apikey", value: apiKey))
        urlQueryItems.append(contentsOf: Self.convertToURLQueryItems(dict: queryItems) ?? [])
        
        return urlQueryItems
    }
    
    func toURLRequest() throws -> URLRequest {
        guard let url = buildURL() else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body?.data()
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = handleQueryItems()
        request.url = components?.url
        
        return request
    }
}

extension NetworkRequest {
    static func convertToURLQueryItems(dict: [String: Any?]?) -> [URLQueryItem]? {
            guard let dict = dict else { return nil }
            
            return dict
                .filter { _, value in value != nil }
                .flatMap { key, value in Self.buildQueryItems(key: key, value: value) }
        }

        static func buildQueryItems(key: String, value: Any?) -> [URLQueryItem] {
            guard let value else {
                return [ URLQueryItem(name: key, value: nil) ]
            }

            switch value {
            case is String:
                return [ URLQueryItem(name: key, value: value as? String) ]
                
            case is Int,
                is Int32,
                is Bool,
                is Double,
                is Float:
                return [ URLQueryItem(name: key, value: String(describing: value)) ]
                
            case let value as [Any]:
                return value
                    .filter { false == ($0 is [Any]) }
                    .flatMap { Self.buildQueryItems(key: key, value: $0) }
                
            default:
                return []
            }
        }
}
