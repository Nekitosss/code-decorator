//
//  Delta.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import CoreGraphics

struct DragDelta: Equatable {
    var topLeft: CGSize = .zero
    var topRight: CGSize = .zero
    var bottomLeft: CGSize = .zero
    var bottomRight: CGSize = .zero
    
    var width: CGFloat {
        topLeft.width + topRight.width + bottomLeft.width + bottomRight.width
    }
    
    var height: CGFloat {
        topLeft.height + topRight.height + bottomLeft.height + bottomRight.height
    }
}
