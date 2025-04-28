//
//  ArrayExtension.swift
//  Hopefully Good News
//
//  Created by Mehmet Altıntaş on 23.04.2025.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element == String {
    func joinedForLabel(separator: String = " - ") -> String {
        self.joined(separator: separator)
    }
}
