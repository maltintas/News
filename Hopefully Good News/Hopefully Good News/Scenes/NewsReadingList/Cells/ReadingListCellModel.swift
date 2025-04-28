//
//  ReadingListCellModel.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import Foundation

protocol ReadingListCellDataSource {
    var newsItem: NewsItem? { get }
    var title: String { get }
    var pubDate: String { get }
    var descriptionText: String { get }
    var newsImageURLString: String? { get }
}

protocol ReadingListCellProtocol: ReadingListCellDataSource {}

final class ReadingListCellModel: ReadingListCellProtocol {
    
    // MARK: - Properties
    var newsItem: NewsItem?
    var title: String { return newsItem?.title ?? "-" }
    var pubDate: String { return newsItem?.pubDate ?? "-" }
    var newsImageURLString: String? { return newsItem?.image_url }
    var descriptionText: String { return newsItem?.description ?? "-" }
    
    // MARK: - Init
    init(newsItem: NewsItem?) {
        self.newsItem = newsItem
    }
}
