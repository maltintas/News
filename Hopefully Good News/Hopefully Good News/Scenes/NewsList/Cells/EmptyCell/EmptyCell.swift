//
//  EmptyCell.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import UIKit

final class EmptyCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(titleText: String? = nil) {
        if let titleText {
            titleLabel.text = titleText
        } else {
            titleLabel.text = "Sonuç bulunamadı"
        }
    }
}
