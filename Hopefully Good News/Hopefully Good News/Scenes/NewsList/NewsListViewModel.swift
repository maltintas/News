//
//  NewsListViewModel.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation
import UIKit

protocol NewsListViewDataSource {
    var numberOfSections: Int { get }
    
    var shouldReloadTableView: (() -> Void)? { get }
    
    func getNextPage() -> String?
    func getNewsListItem(_ indexPath: IndexPath) -> NewsItem?
    func handleReadingList(_ item: NewsItem?)
    func configureBookmarkImage(_ item: NewsItem?) -> String
    func getArticleId(_ indexPath: IndexPath) -> String? 
    
    func sectionAt(index: Int) -> NewsListViewModel.SectionType
    func numberOfRowsInSection(section: Int) -> Int
}

final class NewsListViewModel: NewsListViewDataSource {
    
    // MARK: - Variables
    private let networkManager = NetworkManager()
    private var newsListResponse: NewsListResponse?
    var newsList: [NewsItem] = []
    var sections: [SectionType] = []
    
    var shouldReloadTableView: (() -> Void)?
}

// MARK: - API Calls
extension NewsListViewModel {
    @MainActor
    func getNews(searchText: String? = nil) async {
        let request = NewsListRequest(page: nil, searchText: searchText)
        do {
            newsListResponse = try await networkManager.fetch(request)
            newsList = newsListResponse?.results ?? []
            configureSections()
        } catch {
            newsList.removeAll()
            configureSections()
            shouldReloadTableView?()
            print(error)
        }
    }
    
    @MainActor
    func fetchMoreNews() async {
        guard let nextPage = getNextPage() else { return }
        let request = NewsListRequest(page: nextPage, searchText: nil)
        do {
            newsListResponse = try await networkManager.fetch(request)
            newsList.append(contentsOf: newsListResponse?.results ?? [])
            configureSections()
        } catch {
            print(error)
        }
    }
}

// MARK: - Helpers
extension NewsListViewModel {
    private func configureSections() {
        guard !newsList.isEmpty else {
            sections = [.empty]
            return
        }
        sections = [.list]
    }
    
    func getNextPage() -> String? {
        guard let newsListResponse, let nextPage = newsListResponse.nextPage else { return nil }
        return nextPage
    }
    
    func getNewsListItem(_ indexPath: IndexPath) -> NewsItem? {
        return newsList[safe: indexPath.row]
    }
    
    func getArticleId(_ indexPath: IndexPath) -> String? {
        return newsList[safe: indexPath.row]?.article_id
    }
    
    func handleReadingList(_ item: NewsItem?) {
        guard let item else { return }
        let isAlreadyExist = ReadingListManager.shared.isInReadingList(item)
        if isAlreadyExist {
            ReadingListManager.shared.removeFromReadingList(item)
        } else {
            ReadingListManager.shared.addToReadingList(item)
        }
    }
    
    func configureBookmarkImage(_ item: NewsItem?) -> String {
        guard let item else { return "bookmark" }

        let isAlreadyExist = ReadingListManager.shared.isInReadingList(item)
        return isAlreadyExist ? "bookmark.fill" : "bookmark"
    }
}

// MARK: - TableView Helpers
extension NewsListViewModel {
    var numberOfSections: Int { return sections.count }
    
    func sectionAt(index: Int) -> NewsListViewModel.SectionType {
        guard let sectionAt = sections[safe: index] else { return .none }
        return sectionAt
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch sectionAt(index: section) {
        case .list: return newsList.count
        case .empty: return 1
        case .none: return 0
        }
    }
}

// MARK: - SectionType
extension NewsListViewModel {
    enum SectionType: CaseIterable {
        case list, empty, none
        
        var cellClass: UITableViewCell.Type {
            switch self {
            case .list: return NewsListCell.self
            case .empty: return EmptyCell.self
            case .none: return UITableViewCell.self
            }
        }
    }
}
