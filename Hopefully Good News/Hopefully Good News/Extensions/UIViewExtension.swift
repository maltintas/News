//
//  UIViewExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

import UIKit

private var spinnerView: UIView?

extension UIView {
    
    func roundCorners(radius: CGFloat = 4) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func addShadow(
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4
    ) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}

// MARK: - Loading HUD

public extension UIView {
    func showLoadingHUD() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        
        let overlay = UIView(frame: self.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        spinner.center = overlay.center
        overlay.addSubview(spinner)
        
        self.addSubview(overlay)
        spinnerView = overlay
    }
    
    func hideLoadingHUD() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }
}
