//
//  StringExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 24.04.2025.
//

import Foundation

extension String {
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss", timeZone: TimeZone = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
