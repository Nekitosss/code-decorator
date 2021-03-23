//
//  ImageDropDelegate.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import UIKit
import SwiftUI

struct ImageDropDelegate: DropDelegate {
    
    let handler: (UIImage) -> Void
    
    func performDrop(info: DropInfo) -> Bool {
        guard let provider = info.itemProviders(for: [.image]).first else { return false }
        provider.loadObject(ofClass: UIImage.self) { image, error in
            guard let image = image as? UIImage else { return }
            handler(image)
        }
        return true
    }
    
}
