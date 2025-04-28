//
//  NewsDetailRequest.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import Foundation

struct NewsDetailRequest: NetworkRequest {
    typealias Response = NewsListResponse
    
    let id: String?
    
    var path: String = "1/latest"
    var method: HTTPMethod = .get
    var queryItems: [String : Any?]? {
        var items: [String : Any?] = [:]
        
        if let id {
            items["id"] = id
        }
        
        return items
    }
}
