//
//  ReadingListCell.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import UIKit

final class ReadingListCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Properties
    private var cellViewModel: ReadingListCellProtocol?

    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Configure Cell
    func configureCell(cellViewModel: ReadingListCellModel) {
        self.cellViewModel = cellViewModel
        configureView()
        configureImageView()
        configureLabels()
    }
    
    // MARK: - Helpers
    private func configureLabels() {
        titleLabel.text = cellViewModel?.title
        descriptionLabel.text = cellViewModel?.descriptionText
        dateLabel.text = cellViewModel?.pubDate
    }
    
    private func configureImageView() {
        if let newsImageURL = URL(string: cellViewModel?.newsImageURLString ?? "") {
            newsImageView.kf.setImage(with: newsImageURL)
        }
    }
    
    private func configureView() {
        containerView.roundCorners()
        containerView.addShadow()
        newsImageView.roundCorners()
    }
}
