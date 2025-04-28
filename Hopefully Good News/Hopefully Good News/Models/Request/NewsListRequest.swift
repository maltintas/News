//
//  NewsListRequest.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation

struct NewsListRequest: NetworkRequest {
    typealias Response = NewsListResponse
    
    let page: String?
    let searchText: String?
    
    var path: String = "1/latest"
    var method: HTTPMethod = .get
    var queryItems: [String: Any?]? {
        var items: [String: Any?] = [
            "language": "tr",
            "country": "tr",
            "category": "top"
        ]
        
        if let page {
            items["page"] = page
        }
        
        if let searchText {
            items["q"] = searchText
        }
        
        return items
    }
}
