//
//  ArticleDTO.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation

struct ArticleDTO:Decodable{
    let id: Int
    let title: String
    let body: String
    let userId:Int
    // Optional fields you might have on a real API:
    let thumbnail:String?
    let author:String?
    let publishedAt:String?
}

extension ArticleDTO {
    func toDomain() -> Article{
        Article(id: String(id),
            title: title,
            author: author ?? "User\(userId)" ,
            thumbnailURL: thumbnail.flatMap(URL.init),
            content: body,
            publishedAt: publishedAt.flatMap{ISO8601DateFormatter().date(from:$0)},
            isBookmarked: false)
    }
}
