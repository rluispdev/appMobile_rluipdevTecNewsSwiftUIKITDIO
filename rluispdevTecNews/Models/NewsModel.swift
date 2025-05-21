//
//  NewsModel.swift
//  rluispdevNews
//
//  Created by Rafael Gonzaga on 4/28/25.
//

import Foundation

struct NewsModel: Codable {
    var source: SourceModel
    var author: String?
    var title: String?
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: Date
    var content: String
}
