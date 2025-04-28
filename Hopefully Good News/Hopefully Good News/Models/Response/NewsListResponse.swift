//
//  NewsListResponse.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import Foundation

struct NewsListResponse: Codable {
    let status: String?
    let totalResults: Int?
    let results: [NewsItem]?
    let nextPage: String?
}

struct NewsItem: Codable, Hashable {
    let article_id: String?
    let title: String?
    let link: String?
    let keywords: [String]?
    let creator: [String]?
    let description: String?
    let content: String?
    let pubDate: String?
    let pubDateTZ: String?
    let image_url: String?
    let video_url: String?
    let source_id: String?
    let source_name: String?
    let source_priority: Int?
    let source_url: String?
    let source_icon: String?
    let language: String?
    let country: [String]?
    let category: [String]?
    let sentiment: String?
    let sentiment_stats: String?
    let ai_tag: String?
    let ai_region: String?
    let ai_org: String?
    let duplicate: Bool?
}
