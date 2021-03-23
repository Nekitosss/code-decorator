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

extension UIImage {
    
    func cropImage(to rect: CGRect) -> UIImage? {
        let res = cgImage?.cropping(to: rect).map { UIImage(cgImage: $0) } ?? self
        return res
    }
    
    func stretchImageSides(size: CGSize) -> UIImage? {
        let image = self
        let scale: CGFloat = image.scale
        guard image.size.width < size.width || image.size.height < size.height else {
            return image
        }
        
        var contextSize = CGSize(width: floor(size.width - image.size.width) / 2 + image.size.width,
                                 height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               true, scale)
        
        var resizable = image.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                         left: 0,
                                                                         bottom: 0,
                                                                         right: image.size.width - 1),
                                             resizingMode: .stretch)
        let centerRect = CGRect(x: 0, y: 0, width: contextSize.width, height: contextSize.height)
        resizable.draw(in: centerRect)
        
        var result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        contextSize = CGSize(width: size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               true, scale)
        
        resizable = result.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                      left: result.size.width - 1,
                                                                      bottom: 0,
                                                                      right: 0),
                                          resizingMode: .stretch)
        resizable.draw(in: .init(origin: .zero, size: contextSize))
        result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        contextSize = CGSize(width: size.width, height: ceil(size.height - image.size.height) / 2 + image.size.height)
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               true, scale)
        
        resizable = result.resizableImage(withCapInsets: UIEdgeInsets(top: 0,
                                                                      left: 0,
                                                                      bottom: result.size.height - 1,
                                                                      right: 0),
                                          resizingMode: .stretch)
        resizable.draw(in: .init(origin: .zero, size: contextSize))
        result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        contextSize = size
        UIGraphicsBeginImageContextWithOptions(contextSize,
                                               true, scale)
        
        resizable = result.resizableImage(withCapInsets: UIEdgeInsets(top: result.size.height - 1,
                                                                      left: 0,
                                                                      bottom: 0,
                                                                      right: 0),
                                          resizingMode: .stretch)
        resizable.draw(in: .init(origin: .zero, size: contextSize))
        result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
}

