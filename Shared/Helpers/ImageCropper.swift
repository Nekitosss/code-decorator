//
//  ImageCropper.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import UIKit

struct ImageCropper {
    let initialSize: CGSize
    let containerRect: CGRect
    
    func getCropRect(image: UIImage) -> CGRect {
        let ratio = self.ratio(image: image)
        
        return CGRect(x: ratio * image.scale * (initialSize.width + containerRect.origin.x),
                      y: ratio * image.scale * (initialSize.height + containerRect.origin.y),
                      width: ratio * image.scale * (containerRect.width - containerRect.origin.x),
                      height: ratio * image.scale * (containerRect.height - containerRect.origin.y))
    }
    
    func ratio(image: UIImage) -> CGFloat {
        image.size.width / initialSize.width / ContentView.imageSizeMultiplier
    }
}
