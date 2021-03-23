//
//  TopNavigationModel.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import Foundation
import SwiftUI

struct TopNavigation: Equatable {
    var mac = MacNavigationModel()
    var tag = Tag.mac
    
    enum Tag: Equatable, CaseIterable, StringRepresentable {
        case empty
        case mac
        
        var stringValue: String {
            switch self {
            case .empty:
                return "Empty"
            case .mac:
                return "Mac"
            }
        }
    }
}

struct MacNavigationModel: Equatable {
    var spacing: CGFloat = 10
    var padding: CGFloat = 16
    var background: SystemBackground = .transparent
    
    enum SystemBackground: Equatable, View, CaseIterable, StringRepresentable {
        case transparent
        case light
        case dark
        
        var stringValue: String {
            switch self {
            case .transparent:
                return "Transparent"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            }
        }
        
        var body: some View {
            switch self {
            case .transparent:
                EmptyView()
            case .light:
                Color(.displayP3, red: 251/255, green: 245/255, blue: 246/255, opacity: 1)
            case .dark:
                Color(.displayP3, red: 57/255, green: 54/255, blue: 59/255, opacity: 1)
            }
        }
    }
    
    let side: CGFloat = 15
}
