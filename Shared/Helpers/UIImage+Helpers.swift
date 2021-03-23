//
//  UIImage+Helpers.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import UIKit

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

