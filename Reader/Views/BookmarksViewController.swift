//
//  BookmarksViewController.swift
//  Reader
//
//  Created by Mallikharjuna on 18/08/25.
//

import UIKit

class BookmarksViewController: UIViewController {
    private let viewModel = BookmarksViewModel()
    private let tableView = UITableView()
    private var dataSource: UITableViewDiffableDataSource<Int, Article>!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        setupTable()
        viewModel.onUpdate = { [weak self] in self?.applySnapshot() }
        applySnapshot()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reload() // refresh when returning
    }
    
    private func setupTable() {
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { table, indexPath, article in
            let cell = table.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
            cell.configure(with: article)
            cell.onBookmarkTap = { [weak self] in
                self?.viewModel.removeBookmark(id: article.id)
            }
            return cell
        }
    }
    private func applySnapshot() {
        var snap = NSDiffableDataSourceSnapshot<Int, Article>()
        snap.appendSections([0])
        snap.appendItems(viewModel.articles, toSection: 0)
        dataSource.apply(snap, animatingDifferences: true)
    }


}
