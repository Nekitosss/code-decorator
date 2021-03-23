//
//  ImageFile.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import Foundation
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct ImageFile: FileDocument {
    
    enum ErrorType: Error {
        case parseError
    }
    
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let image = UIImage(data: data)
        else { throw ErrorType.parseError }
        self.image = image
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        guard let data = image.pngData() else {
            throw ErrorType.parseError
        }
        
        let wrapper = FileWrapper(regularFileWithContents: data)
        wrapper.filename = "decorated.png"
        
        return wrapper
    }
    
    static var readableContentTypes: [UTType] { [.image] }
    static var writableContentTypes: [UTType] { [.image] }
    
}
