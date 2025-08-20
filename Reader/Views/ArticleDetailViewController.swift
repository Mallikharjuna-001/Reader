//
//  ArticleDetailViewController.swift
//  Reader
//
//  Created by Mallikharjuna on 18/08/25.
//

import UIKit

class ArticleDetailViewController: UIViewController {
    var article: Article
    private let shadowContainer = UIView()
    let thumbImage = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let contentLabel = UILabel()
    let bookmarkButton = UIButton(type: .system)
    
    init(article: Article) {

        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setupHeroImage()
        setupUI()
        configure(with: article)
    }
    private func setupUI() {
        thumbImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0

        authorLabel.font = .systemFont(ofSize: 15)
        authorLabel.textColor = .secondaryLabel

        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0

        let config = UIImage.SymbolConfiguration(pointSize: 24)
        bookmarkButton.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        bookmarkButton.tintColor = .systemBlue
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)

       // view.addSubview(shadowContainer)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(contentLabel)
        view.addSubview(bookmarkButton)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: thumbImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),

            bookmarkButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            bookmarkButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupHeroImage() {
            // Container for shadow
            shadowContainer.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(shadowContainer)

            // Image view with rounded corners
            thumbImage.translatesAutoresizingMaskIntoConstraints = false
            thumbImage.contentMode = .scaleAspectFill
            thumbImage.clipsToBounds = true
            thumbImage.layer.cornerRadius = 16    // 👈 corner radius
            thumbImage.image = UIImage(named: "placeholder") // replace with your image

            shadowContainer.addSubview(thumbImage)

            // Layout: full width with margins, 16:9 aspect ratio (adjust if needed)
            NSLayoutConstraint.activate([
                shadowContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                shadowContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                shadowContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

                // Keep a consistent height via aspect ratio
                shadowContainer.heightAnchor.constraint(equalTo: shadowContainer.widthAnchor, multiplier: 9.0/16.0),

                // Image pinned inside container
                thumbImage.topAnchor.constraint(equalTo: shadowContainer.topAnchor),
                thumbImage.leadingAnchor.constraint(equalTo: shadowContainer.leadingAnchor),
                thumbImage.trailingAnchor.constraint(equalTo: shadowContainer.trailingAnchor),
                thumbImage.bottomAnchor.constraint(equalTo: shadowContainer.bottomAnchor),
            ])

            // Shadow on container (NOT on image)
            shadowContainer.layer.shadowColor = UIColor.black.cgColor
            shadowContainer.layer.shadowOpacity = 0.18
            shadowContainer.layer.shadowRadius = 12
            shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 8)

            // Improve performance: set a shadowPath once you know the frame
            // (do it in viewDidLayoutSubviews so it updates on rotation)
        }

    private func configure(with article: Article) {
        titleLabel.text = article.title.capitalized
        authorLabel.text = "By \(article.author?.capitalized ?? "Unknown")"
        contentLabel.text = article.content?.capitalized ?? "No content available"

        if let url = article.thumbnailURL {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.thumbImage.image = UIImage(data: data)
                    }
                }
            }.resume()
        }

        let icon = article.isBookmarked ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    @objc private func toggleBookmark() {
        // TODO: update persistence (CoreData/Realm/UserDefaults)
        let newState = !article.isBookmarked
        let icon = newState ? "bookmark.fill" : "bookmark"
        bookmarkButton.setImage(UIImage(systemName: icon), for: .normal)
    }
    

}
