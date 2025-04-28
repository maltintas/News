//
//  PlistManager.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 28.04.2025.
//

import Foundation

enum Constants {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "NetworkConstants", ofType: "plist"),
              let routeDictionary = NSDictionary(contentsOfFile: path),
              let key = routeDictionary["apiKey"] as? String else { return "" }
        return key
    }
    
    static var baseURL: String {
        guard let path = Bundle.main.path(forResource: "NetworkConstants", ofType: "plist"),
              let routeDictionary = NSDictionary(contentsOfFile: path),
              let key = routeDictionary["baseURL"] as? String else { return "" }
        return key
    }
}
