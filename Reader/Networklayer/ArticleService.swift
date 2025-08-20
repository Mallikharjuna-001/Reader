//
//  ArticleService.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation

protocol ArticleServiceProtocol {
    func fetchArticles() async throws -> [Article]
}

final class ArticleService:ArticleServiceProtocol {
    private let api =  ApiClient()
    private let endpoint = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchArticles() async throws -> [Article] {
        let dtos:[ArticleDTO] = try await api.get(endpoint)
        print(dtos)
        return dtos.map { dto in
            var a = dto.toDomain()
            if a.thumbnailURL == nil{
                 a = Article(
                    id: a.id,
                    title: a.title,
                    author: a.author,
                    thumbnailURL: URL(string: "https://picsum.photos/seed/\(a.id)/200/200"),
                    content: a.content,
                    publishedAt: a.publishedAt,
                    isBookmarked: a.isBookmarked
                 )
            }
            return a
        }
    }
    
}
