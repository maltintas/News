//
//  NewsListCellModel.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation

protocol NewsListCellDataSource {
    var newsItem: NewsItem? { get }
    var title: String { get }
    var pubDate: String { get }
    var keywords: [String] { get }
    var newsImageURLString: String? { get }
    var newsSourceImageURLString: String? { get }
    var sourceName: String { get }
    var descriptionText: String { get }
    
    func configureKeywords() -> String
}

protocol NewsListCellProtocol: NewsListCellDataSource {}

final class NewsListCellModel: NewsListCellProtocol {
    
    // MARK: - Properties
    var newsItem: NewsItem?
    var title: String { return newsItem?.title ?? "-" }
    var pubDate: String { return newsItem?.pubDate ?? "-" }
    var keywords: [String] { return newsItem?.keywords ?? [] }
    var newsImageURLString: String? { return newsItem?.image_url }
    var newsSourceImageURLString: String? { return newsItem?.source_icon }
    var sourceName: String { return newsItem?.source_name ?? "-" }
    var descriptionText: String { return newsItem?.description ?? "-" }
    
    // MARK: - Init
    init(newsItem: NewsItem?) {
        self.newsItem = newsItem
    }
    
    func configureKeywords() -> String {
        return "\(sourceName) - \(keywords.joinedForLabel(separator: ", "))"
    }
}
