//
//  BubbledButtonStyle.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import SwiftUI

struct BubbledButtonStyle: ButtonStyle {
    
    static var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .mac ? 14 : 20
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: BubbledButtonStyle.fontSize))
            .foregroundColor(configuration.isPressed ? Color.blue.opacity(0.5) : .blue)
            .frame(maxHeight: TopControlsView.height)
            .padding(.horizontal)
            .overlay(Capsule().stroke(Color(.separator)))
    }
    
}
