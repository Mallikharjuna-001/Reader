//
//  ViewController.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import UIKit

class ArticlesViewController: UIViewController,UITableViewDelegate {
    
    private let tableView = UITableView()
    private var datasource :UITableViewDiffableDataSource<Int, Article>!
    private let viewModel = ArticlesViewModel()
    private let refresh = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    private let activity = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Articles"
        view.backgroundColor = .systemBackground
        setupTable()
        setupSearch()
        setupBindings()
        Task {
            await viewModel.refresh()
        }
        
        
    }

    private func setupTable(){
        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseID)
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(pulled), for: .valueChanged)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        datasource = UITableViewDiffableDataSource(tableView: tableView) { table, indexPath, article in
            let cell = table.dequeueReusableCell(withIdentifier: ArticleCell.reuseID, for: indexPath) as! ArticleCell
            cell.configure(with: article)
            cell.onBookmarkTap = { [weak self] in
                self?.viewModel.toggleBookmark(id: article.id)
            }
            return cell
      }
    }
    
        private func setupSearch() {
            searchController.searchBar.placeholder = "Search titles"
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchResultsUpdater = self
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        }
        private func setupBindings() {
            viewModel.onUpdate = { [weak self] in
                guard let self = self else { return }
                    DispatchQueue.main.async {
                        let uniqueArticles = Dictionary(grouping: self.viewModel.articles, by: { $0.id })
                    .compactMap { $0.value.first }

                    var snap = NSDiffableDataSourceSnapshot<Int, Article>()
                    snap.appendSections([0])
                    snap.appendItems(uniqueArticles, toSection: 0)
                    self.datasource.apply(snap, animatingDifferences: true)
                    self.refresh.endRefreshing()
                }
                
                switch self.viewModel.state {
                case .loading: self.activity.startAnimating()
                default: self.activity.stopAnimating()
                }
            }
        }
    @objc private func pulled(){
        Task{
            await viewModel.refresh()
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

          if let article = datasource.itemIdentifier(for: indexPath) {
               let detailVC = ArticleDetailViewController(article: article)
                navigationController?.pushViewController(detailVC, animated: true)
            }

        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    }

extension ArticlesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(by: searchController.searchBar.text ?? "")
    }
}

