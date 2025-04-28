//
//  NewsDetailViewModel.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import Foundation

protocol NewsDetailViewDataSource {
    var articleId: String? { get set }
    var newsImageURLString: String { get }
    var titleText: String { get }
    var sourceImageURLString: String { get }
    var descriptionText: String { get }
    var sourceNameText: String { get }
    var keywordsText: String { get }
    var sourceURLString: String? { get }
    var publishDateText: String { get }
    
    func getNews() async
}

protocol NewsDetailViewProtocol: NewsDetailViewDataSource {}

final class NewsDetailViewModel: NewsDetailViewProtocol {
    
    // MARK: - Properties
    var articleId: String?
    var newsImageURLString: String { return newsItem?.image_url ?? "" }
    var titleText: String { return newsItem?.title ?? "" }
    var sourceImageURLString: String { return newsItem?.source_icon ?? "" }
    var descriptionText: String { return newsItem?.description ?? "" }
    var sourceNameText: String { return newsItem?.source_name ?? "" }
    var keywordsText: String { return newsItem?.keywords?.joinedForLabel(separator: ", ") ?? "" }
    var sourceURLString: String? { return newsItem?.source_url ?? "" }
    var publishDateText: String { return newsItem?.pubDate ?? "" }
    
    private let networkManager = NetworkManager()
    private var newsItem: NewsItem?
}

// MARK: - API Call
extension NewsDetailViewModel {
    @MainActor
    func getNews() async {
        let request = NewsDetailRequest(id: articleId)
        do {
            newsItem = try await networkManager.fetch(request).results?.first
        } catch {
            print(error)
        }
    }
}
