//
//  ArticleRepositoryProtocol.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation
import CoreData

protocol ArticleRepositoryProtocol {
    func upsert(_ articles: [Article])
    func fetchAll() -> [Article]
    func search(by query: String) -> [Article]
    func setBookmarked(id: String, bookmarked: Bool)
    func fetchBookmarked() -> [Article]
}
final class ArticleRepository:ArticleRepositoryProtocol {

    private let coreDataStckContext = CoreDataStack.shared.context
    
    
    func upsert(_ articles: [Article]) {
        let ids = articles.map {
            $0.id
            
        }
        
        let fetch: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetch.predicate = NSPredicate(format: "id IN %@", ids)
        let existing = (try? coreDataStckContext.fetch(fetch)) ?? []
        let map = [String: ArticleEntity]()
        
        for article in articles {
            let entity = map[article.id] ?? ArticleEntity(context: coreDataStckContext)
            entity.id = article.id
            entity.title = article.title
            entity.author = article.author
            entity.thumbnailURL = article.thumbnailURL?.absoluteString
            entity.content = article.content
            entity.publishedAt = article.publishedAt
            // keep bookmarks persistent
            if entity.managedObjectContext?.insertedObjects.contains(entity) == true {
                entity.isBookmarked = article.isBookmarked
            }
        }
        CoreDataStack.shared.save()
    }
    
      func fetchAll() -> [Article] {
        let req: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? coreDataStckContext.fetch(req))?.map { $0.toDomain() } ?? []
     }
    func search(by query: String) -> [Article] {
        guard !query.isEmpty else {
            return fetchAll()
            
        }
        let req: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        req.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? coreDataStckContext.fetch(req))?.map { $0.toDomain() } ?? []
    }
    
    func setBookmarked(id: String, bookmarked: Bool) {
        let req: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id)
        if let e = try? coreDataStckContext.fetch(req).first {
            e.isBookmarked = bookmarked
            CoreDataStack.shared.save()
        }
    }
    func fetchBookmarked() -> [Article] {
        let req: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        req.predicate = NSPredicate(format: "isBookmarked == YES")
        req.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? coreDataStckContext.fetch(req))?.map { $0.toDomain() } ?? []
    }
}
private extension ArticleEntity {
    func toDomain() -> Article {
        Article(
            id: id ?? UUID().uuidString,
            title: title ?? "",
            author: author,
            thumbnailURL: thumbnailURL.flatMap(URL.init),
            content: content,
            publishedAt: publishedAt,
            isBookmarked: isBookmarked
        )
    }
}
