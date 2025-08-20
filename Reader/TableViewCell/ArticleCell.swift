//
//  ArticleCell.swift
//  Reader
//
//  Created by Mallikharjuna on 18/08/25.
//

import UIKit

final class ArticleCell: UITableViewCell {
    static let reuseID = "ArticleCell"
    private let thumb = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let bookmark = UIButton(type: .system)

    var onBookmarkTap: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder);  }

    private func setup() {
        thumb.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        thumb.contentMode = .scaleAspectFill
        thumb.clipsToBounds = true
        thumb.layer.cornerRadius = 8

        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .black
        subtitleLabel.backgroundColor = .yellow
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        bookmark.setImage(UIImage(systemName: "bookmark", withConfiguration: config), for: .normal)
        bookmark.tintColor = .systemBlue
        bookmark.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)

        contentView.addSubview(thumb)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(bookmark)

        NSLayoutConstraint.activate([
            thumb.widthAnchor.constraint(equalToConstant: 64),
            thumb.heightAnchor.constraint(equalToConstant: 64),
            thumb.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            thumb.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: thumb.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            bookmark.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bookmark.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            bookmark.widthAnchor.constraint(equalToConstant: 30),
            bookmark.heightAnchor.constraint(equalToConstant: 30),
            
            

        ])
        accessoryType = .disclosureIndicator
        selectionStyle = .default
    }

    @objc private func bookmarkTapped() {
        onBookmarkTap?()
        
    }

    func configure(with article: Article) {
        
        titleLabel.text = article.title.capitalized
        subtitleLabel.text = article.author
        bookmark.isSelected = article.isBookmarked
        if let url = article.thumbnailURL {
            ImageLoader.shared.load(url, into: thumb)
        } else {
            thumb.image = UIImage(systemName: "photo")
        }
    }
}

