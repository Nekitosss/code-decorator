//
//  EditorModel.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import CoreGraphics

struct EditorModel: Equatable {
    var backgroundPadding: CGFloat = 24
    var shadowBlurRadius: CGFloat = 8
    var cornerRadius: CGFloat = 8
    var navigation: TopNavigation = TopNavigation()
    var background: BackgroundModel = .init()
}
