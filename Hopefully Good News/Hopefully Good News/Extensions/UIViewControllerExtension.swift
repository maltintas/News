//
//  UIViewControllerExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String,
        message: String,
        buttonTitle: String = "Tamam",
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func configureNavigationTitle(_ title: String, prefersLargeTitles: Bool = true) {
        self.title = title
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.largeTitleDisplayMode = prefersLargeTitles ? .always : .never
    }
    
    func addNavigationBarButton(title: String? = nil,
                                systemImageName: String? = nil,
                                position: NSLayoutConstraint.Attribute = .right,
                                action: Selector) {
        let button: UIBarButtonItem
       
        if let imageName = systemImageName {
            button = UIBarButtonItem(image: UIImage(systemName: imageName),
                                     style: .plain,
                                     target: self,
                                     action: action)
        } else if let title {
            button = UIBarButtonItem(title: title,
                                     style: .plain,
                                     target: self,
                                     action: action)
        } else {
            return
        }
        
        button.tintColor = .systemRed
        
        switch position {
        case .left:
            navigationItem.leftBarButtonItem = button
        default:
            navigationItem.rightBarButtonItem = button
        }
    }
}
