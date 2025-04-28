//
//  NewsReadingListVC.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 25.04.2025.
//

import UIKit

final class NewsReadingListVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let viewModel = NewsReadingListViewModel(newsReadingList: ReadingListManager.shared.getReadingList())
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Config
    func configureUI() {
        configureNavigationTitle("Reading List", prefersLargeTitles: false)
        configureTableView()
    }
}

// MARK: - Configure TableView
private extension NewsReadingListVC {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        registerCell()
    }

    private func registerCell() {
        NewsReadingListViewModel.SectionType.allCases.forEach { sectionType in
            tableView.register(nibWithCellClass: sectionType.cellClass)
        }
    }
}

// MARK: - TableView Cell Data Source
private extension NewsReadingListVC {
    private func getNewsReadingListCell(_ indexPath: IndexPath) -> UITableViewCell {
        let newsItem = viewModel.getNewsListItem(indexPath)
        let cellViewModel = ReadingListCellModel(newsItem: newsItem)
        let cell = tableView.dequeueReusableCell(withClass: ReadingListCell.self, for: indexPath)
        cell.configureCell(cellViewModel: cellViewModel)
        return cell
    }
    
    private func getEmptyCell(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: EmptyCell.self)
        cell.configureCell(titleText: "Okuma listesi boş")
        return cell
    }
}

// MARK: - TableView Data Source
extension NewsReadingListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.sectionAt(index: indexPath.section) {
        case .list: return getNewsReadingListCell(indexPath)
        case .empty: return getEmptyCell(indexPath)
        case .none: return UITableViewCell()
        }
    }
}

// MARK: - TableView Delegate
extension NewsReadingListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch viewModel.sectionAt(index: indexPath.section) {
        case .list:
            guard let articleId = viewModel.getArticleId(at: indexPath.section) else { return }
            navigateToDetail(articleId: articleId)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completionHandler) in
            guard let self, let selectedItem = viewModel.getNewsListItem(indexPath) else { return }
            
            ReadingListManager.shared.removeFromReadingList(selectedItem)
            viewModel.removeItem(at: indexPath.row)
            tableView.reloadData()
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

// MARK: - Navigation
private extension NewsReadingListVC {
    private func navigateToDetail(articleId: String) {
        var viewModel: NewsDetailViewProtocol = NewsDetailViewModel()
        viewModel.articleId = articleId
        let vc = NewsDetailVC(viewModel: viewModel)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true)
    }
}
