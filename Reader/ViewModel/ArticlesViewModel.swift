//
//  ArticlesViewModel.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation

@MainActor
final class ArticlesViewModel {
    enum State {
        case idle,
             loading,
             loaded,
             error(String)
    }
    private let service: ArticleServiceProtocol
    private let repo: ArticleRepositoryProtocol
    private(set) var state: State = .idle
    private(set) var articles: [Article] = []
    var onUpdate: (() -> Void)?
    
    init(service:ArticleServiceProtocol = ArticleService(),repo:ArticleRepositoryProtocol = ArticleRepository()){
        self.service = service
        self.repo = repo
        // start with cached data for fast first paint
         self.articles = repo.fetchAll()
    }
    
    func refresh() async {
        state = .loading; onUpdate?()
        do {
            let remote = try await service.fetchArticles()
            repo.upsert(remote)
            articles = repo.fetchAll()
            state = .loaded
        } catch {
            // Fall back to cache
            articles = repo.fetchAll()
            state = .error("Offline – showing cached")
        }
        onUpdate?()
    }
    
    func filter(by query: String) {
        articles = repo.search(by: query)
        onUpdate?()
    }
    func toggleBookmark(id: String) {
        guard let idx = articles.firstIndex(where: { $0.id == id }) else { return }
        let new = !articles[idx].isBookmarked
        repo.setBookmarked(id: id, bookmarked: new)
        articles[idx].isBookmarked = new
        onUpdate?()
    }
}
