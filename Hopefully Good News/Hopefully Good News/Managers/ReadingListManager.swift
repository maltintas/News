//
//  ReadingListManager.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 25.04.2025.
//

import Foundation

class ReadingListManager {
    static let shared = ReadingListManager()
    private let userDefaultsKey = "ReadingList"
    
    private func save(items: Set<NewsItem>) {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func addToReadingList(_ item: NewsItem) {
        var items = getReadingList()
        items.insert(item)
        save(items: items)
    }
    
    
    func removeFromReadingList(_ item: NewsItem) {
        var items = getReadingList()
        items.remove(item)
        save(items: items)
    }
    
    func isInReadingList(_ item: NewsItem) -> Bool {
        return getReadingList().contains(item)
    }
    
    func getReadingList() -> Set<NewsItem> {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode(Set<NewsItem>.self, from: data) else {
            return []
        }
        return decoded
    }
}
