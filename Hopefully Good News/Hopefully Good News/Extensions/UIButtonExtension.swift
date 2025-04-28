//
//  UIButtonExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import UIKit

extension UIButton {
    func setUnderlinedTitle(_ title: String, font: UIFont? = UIFont.systemFont(ofSize: 14, weight: .regular), color: UIColor? = .systemBlue) {
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        if let font = font {
            attributes[.font] = font
        }
        
        if let color = color {
            attributes[.foregroundColor] = color
        }
        
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
