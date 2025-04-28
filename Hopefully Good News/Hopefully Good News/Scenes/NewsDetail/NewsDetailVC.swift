//
//  NewsDetailVC.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import UIKit
import Kingfisher

final class NewsDetailVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var sourceImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var keywordsLabel: UILabel!
    @IBOutlet private weak var showSourcePageButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var containerView: UIView!
    
    // MARK: - Properties
    var viewModel: NewsDetailViewProtocol
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        apiCall()
    }
    
    init (viewModel: NewsDetailViewProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @IBAction private func buttonAction(_ sender: Any) {
        guard let sourceURL = URL(string: viewModel.sourceURLString ?? "") else { return }
        UIApplication.shared.open(sourceURL)
    }
    
    // MARK: - UI Config
    func configureUI() {
        showSourcePageButton.setUnderlinedTitle(viewModel.sourceURLString ?? "")
        setupImageViews()
        setupLabels()
    }
    
    private func setupImageViews() {
        newsImageView.layer.cornerRadius = 8
        newsImageView.clipsToBounds = true
        sourceImageView.layer.cornerRadius = 8
        sourceImageView.clipsToBounds = true
        if let imageURL = URL(string: viewModel.newsImageURLString) {
            newsImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        if let imageURL = URL(string: viewModel.sourceImageURLString) {
            sourceImageView.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "photo.fill"))
        }
    }
    
    private func setupLabels() {
        titleLabel.text = viewModel.titleText
        descriptionLabel.text = viewModel.descriptionText
        sourceLabel.text = viewModel.sourceNameText
        publishDateLabel.text = viewModel.publishDateText
        keywordsLabel.text = viewModel.keywordsText
    }
}

extension NewsDetailVC {
    private func apiCall() {
        self.containerView.showLoadingHUD()
        
        Task {
            await viewModel.getNews()
            self.containerView.hideLoadingHUD()
            configureUI()
        }
    }
}
