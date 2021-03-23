//
//  MacOverlayView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import SwiftUI

struct MacOverlayView: View {
    let ratio: CGFloat
    let model: MacNavigationModel
    
    private var side: CGFloat {
        model.side / ratio
    }
    
    var body: some View {
        VStack {
            HStack(spacing: model.spacing / ratio) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: side, height: side)
                Circle()
                    .foregroundColor(.orange)
                    .frame(width: side, height: side)
                Circle()
                    .foregroundColor(.green)
                    .frame(width: side, height: side)
                Spacer()
            }
            .padding(model.padding / ratio)
            .background(model.background)
            Spacer()
        }
    }
}
