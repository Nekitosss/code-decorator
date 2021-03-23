//
//  TopNavigation.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import CoreGraphics
import SwiftUI

struct TopNavigationView: View {
    
    let navigationType: TopNavigation
    let imageSize: CGSize
    let initialSize: CGSize
    let forImageDrawingContext: Bool
    
    private var ratio: CGFloat {
        forImageDrawingContext ? 1 : imageSize.width / initialSize.width / ContentView.imageSizeMultiplier
    }
    
    var body: some View {
        switch navigationType.tag {
        case .mac:
            MacOverlayView(ratio: ratio, model: navigationType.mac)
        case .empty:
            EmptyView()
        }
    }
    
}
