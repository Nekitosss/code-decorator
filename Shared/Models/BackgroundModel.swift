//
//  BackgroundModel.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import SwiftUI

struct BackgroundModel: Equatable, View {
    var color: Color = .white
    var gradient: Gradient = .init(start: .purple, end: .yellow)
    var image: ImageType = .notSelected
    var blurRadius: CGFloat = 12
    var isBlurEnabled: Bool = false
    
    var tagValue: Tag = .color
    
    enum ImageType: Equatable, View {
        case notSelected
        case image(UIImage)
        
        var body: some View {
            switch self {
            case let .image(image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .notSelected:
                Color.white
            }
        }
    }
    
    enum Tag: Equatable, CaseIterable {
        case color
        case gradient
        case image
        
        var stringValue: String {
            switch self {
            case .color:
                return "Color"
            case .gradient:
                return "Gradient"
            case .image:
                return "Image"
            }
        }
    }
    
    struct Gradient: Equatable {
        var start: Color
        var end: Color
        let startPoint: UnitPoint = .topLeading
        let endPoint: UnitPoint = .bottomTrailing
        
        var swiftUI: some View {
            LinearGradient(gradient: SwiftUI.Gradient(colors: [start, end]), startPoint: startPoint, endPoint: endPoint)
        }
    }
    
    var body: some View {
        switch tagValue {
        case .color:
            color
        case .gradient:
            gradient.swiftUI
        case .image:
            image
                .blur(radius: isBlurEnabled ? blurRadius : 0)
        }
    }
}
