//
//  Article.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation

struct Article:Identifiable,Hashable{
    let id: String
    let title: String
    let author: String?
    let thumbnailURL: URL?
    let content: String?
    let publishedAt:Date?
    var isBookmarked:Bool
    
}
extension Article {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}
