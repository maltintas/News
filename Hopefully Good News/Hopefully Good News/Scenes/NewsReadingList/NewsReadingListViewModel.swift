//
//  NewsReadingListViewModel.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 25.04.2025.
//

import UIKit

protocol NewsReadingListViewDataSource {
    var numberOfSections: Int { get }
    
    func getNewsListItem(_ indexPath: IndexPath) -> NewsItem?
    func removeItem(at index: Int)
    func sectionAt(index: Int) -> NewsReadingListViewModel.SectionType
    func numberOfRowsInSection(section: Int) -> Int
    func getArticleId(at index: Int) -> String?
}

final class NewsReadingListViewModel: NewsReadingListViewDataSource {

    // MARK: - Variables
    var newsReadingList: Set<NewsItem>
    var newsReadingListArray: [NewsItem] { Array(newsReadingList).sorted { $0.pubDate ?? "" > $1.pubDate ?? "" } }
    
    init(newsReadingList: Set<NewsItem>) {
        self.newsReadingList = newsReadingList
    }
}

// MARK: - Helpers
extension NewsReadingListViewModel {
    private func configureSections() -> [SectionType] {
        guard !newsReadingListArray.isEmpty else {
            return [.empty]
        }
        return [.list]
    }
    
    func getNewsListItem(_ indexPath: IndexPath) -> NewsItem? {
        return newsReadingListArray[safe: indexPath.row]
    }
    
    func removeItem(at index: Int) {
        let itemToRemove = newsReadingListArray[index]
        newsReadingList.remove(itemToRemove)
    }
    
    func getArticleId(at index: Int) -> String? {
        return newsReadingListArray[safe: index]?.article_id
    }
}

// MARK: - TableView Helpers
extension NewsReadingListViewModel {
    var numberOfSections: Int { return configureSections().count }
    
    func sectionAt(index: Int) -> NewsReadingListViewModel.SectionType {
        guard let sectionAt = configureSections()[safe: index] else { return .none }
        return sectionAt
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch sectionAt(index: section) {
        case .list: return newsReadingListArray.count
        case .empty: return 1
        default: return 0
        }
    }
}

// MARK: - SectionType
extension NewsReadingListViewModel {
        enum SectionType: CaseIterable {
            case list, empty, none
        
        var cellClass: UITableViewCell.Type {
            switch self {
            case .list: return ReadingListCell.self
            case .empty: return EmptyCell.self
            case .none: return UITableViewCell.self
            }
        }
    }
}
