//
//  ResizableImageView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 20.03.2021.
//

import SwiftUI
import UIKit

struct ResizableImageView: View {
    
    let image: UIImage
    let initialSize: CGSize
    let containerRect: CGRect
    
    
    var body: some View {
        Image(uiImage: image.cropImage(to: croppedImageRect)!)
            .resizable()
    }
    
    private var croppedImageRect: CGRect {
        ImageCropper(initialSize: initialSize, containerRect: containerRect)
            .getCropRect(image: image)
    }
}
