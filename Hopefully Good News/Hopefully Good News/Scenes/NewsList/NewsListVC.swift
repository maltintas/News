//
//  NewsListVC.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import UIKit

final class NewsListVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = NewsListViewModel()
    private var timer: Timer?
    
    // MARK: - View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiCall()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.shouldReloadTableView = { [weak self] in
            guard let self else { return }
            tableView.reloadData()
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    // MARK: - UI Config
    func configureUI() {
        configureNavigationTitle("Hopefully Good News")
        configureTableView()
        configureSearchBar()
        addNavigationBarButton(systemImageName: "books.vertical.fill", action: #selector(tappedNavigationBarButton))
    }
    
    // MARK: - API Call
    private func apiCall() {
        if viewModel.newsList.isEmpty {
            self.view.showLoadingHUD()
        }
        
        Task {
            await viewModel.getNews()
            self.view.hideLoadingHUD()
            tableView.reloadData()
        }
        
        startPeriodicRefresh()
    }
    
    private func fetchMore() {
        Task {
            await viewModel.fetchMoreNews()
            tableView.reloadData()
        }
    }
    
    func startPeriodicRefresh() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self else { return }
            apiCall()
        }
    }
}

// MARK: - Actions
private extension NewsListVC {
    @objc
    private func tappedNavigationBarButton() {
       navigateToReadingList()
    }
    
    @objc
    private func handleRefresh() {
        Task {
            await viewModel.getNews()
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Configure TableView
private extension NewsListVC {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()
        setupRefreshControl()
    }
    
    private func registerCell() {
        NewsListViewModel.SectionType.allCases.forEach { sectionType in
            tableView.register(nibWithCellClass: sectionType.cellClass)
        }
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
}

// MARK: - TableView Cell Data Source
private extension NewsListVC {
    private func getNewsListCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = NewsListCellModel(newsItem: viewModel.getNewsListItem(indexPath))
        let cell = tableView.dequeueReusableCell(withClass: NewsListCell.self, for: indexPath)
        cell.configureCell(cellViewModel: cellViewModel)
        return cell
    }
    
    private func getEmptyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: EmptyCell.self)
        let text = navigationItem.searchController?.searchBar.placeholder != nil ? "Bilinmeyen bir hata oluştu tekrar deneyin" : "Sonuç bulunamadı"
        cell.configureCell(titleText: text)
        return cell
    }
}

// MARK: - TableView Data Source
extension NewsListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sectionAt(index: indexPath.section) {
        case .list: return getNewsListCell(indexPath)
        case .empty: return getEmptyCell(indexPath)
        case .none: return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate
extension NewsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sectionAt(index: indexPath.section) {
        case .list:
            guard let articleId = viewModel.getArticleId(indexPath) else { return }
            navigateToDetail(articleId: articleId)
        default : break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !viewModel.newsList.isEmpty, indexPath.row == viewModel.newsList.count - 2 {
            fetchMore()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let readLaterAction = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completionHandler) in
            guard let self, let selectedItem = viewModel.getNewsListItem(indexPath) else { return }
            viewModel.handleReadingList(selectedItem)
            completionHandler(true)
        }
        
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium)
        readLaterAction.image = UIImage(systemName: viewModel.configureBookmarkImage(viewModel.getNewsListItem(indexPath)), withConfiguration: config)?
            .withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        
        readLaterAction.backgroundColor = .systemGray6
        
        let configuration = UISwipeActionsConfiguration(actions: [readLaterAction])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}

// MARK: - Search Bar
extension NewsListVC {
    func configureSearchBar(placeHolder: String = "Haber ara...") {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = placeHolder
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
}

// MARK: - UISearchbar Delegate
extension NewsListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await viewModel.getNews(searchText: searchBar.text ?? "")
            tableView.reloadData()
        }
    }
}

// MARK: - Navigations
private extension NewsListVC {
    private func navigateToReadingList() {
        let vc = NewsReadingListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToDetail(articleId: String) {
        var viewModel: NewsDetailViewProtocol = NewsDetailViewModel()
        viewModel.articleId = articleId
        let vc = NewsDetailVC(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
