//
//  ImageImporter.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import Foundation
import UIKit

struct ImageImporter {
    
    static func importImage(result: Result<[URL], Error>, handler: (UIImage) -> Void) {
        switch result {
        case .success(let urls):
            guard let imageURL = urls.first else { break }
            do {
                let imageData = try Data(contentsOf: imageURL)
                guard let image = UIImage(data: imageData) else { break }
                handler(image)
                
            } catch {
                break
            }
        case .failure:
            break
        }
    }
}
