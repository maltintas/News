//
//  UIApplicationExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 26.04.2025.
//

import UIKit

extension UIApplication {
    static func openInSafari(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        shared.open(url)
    }
}
