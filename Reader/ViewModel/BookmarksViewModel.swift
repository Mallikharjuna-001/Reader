//
//  BookmarksViewModel.swift
//  Reader
//
//  Created by Mallikharjuna on 18/08/25.
//

import Foundation

@MainActor
final class BookmarksViewModel {
    private let repository : ArticleRepositoryProtocol
    private (set) var articles :[Article] = []
    var onUpdate:(() -> Void)?
    
    
    init(repo:ArticleRepositoryProtocol = ArticleRepository()){
        self.repository = repo
    
    }
    func reload() {
        articles = repository.fetchBookmarked()
        onUpdate?()
    }
    func removeBookmark(id: String) {
        repository.setBookmarked(id: id, bookmarked: false)
        reload()
    }
}
