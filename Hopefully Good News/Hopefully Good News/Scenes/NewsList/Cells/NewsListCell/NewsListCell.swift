//
//  NewsListCell.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import UIKit
import Kingfisher

final class NewsListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var sourceImageView: UIImageView!
    @IBOutlet private weak var keywordsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    private var cellViewModel: NewsListCellProtocol?

    // MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        sourceImageView.image = nil
    }
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Configure Cell
    func configureCell(cellViewModel: NewsListCellModel) {
        self.cellViewModel = cellViewModel
        setupUI()
        configureLabels()
        configureImageViews()
    }
    
    // MARK: - Helpers
    private func configureLabels() {
        titleLabel.text = cellViewModel?.title
        dateLabel.text = cellViewModel?.pubDate
        descriptionLabel.text = cellViewModel?.descriptionText
        keywordsLabel.text = cellViewModel?.configureKeywords()
    }
    
    private func configureImageViews() {
        if let newsImageURL = URL(string: cellViewModel?.newsImageURLString ?? "") {
            newsImageView.kf.setImage(with: newsImageURL, placeholder: UIImage(systemName: "photo.fill"))
        }
        
        if let sourceImageURL = URL(string: cellViewModel?.newsSourceImageURLString ?? "") {
            sourceImageView.kf.setImage(with: sourceImageURL, placeholder: UIImage(systemName: "photo.fill"))
        }
    }
    
    private func setupUI() {
        containerView.roundCorners()
        containerView.addShadow()
        newsImageView.roundCorners()
        sourceImageView.roundCorners()
    }
}
