//
//  DigitFormatter.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import Foundation

struct DigitFormatter {
    static let shared: Formatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter
    }()
}
