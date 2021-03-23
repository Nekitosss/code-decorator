//
//  DocumentPicker.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 22.03.2021.
//

import Foundation
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var isActive: Bool
    @Binding var image: Background.ImageType
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.image], asCopy: true)
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(owner: self)
    }

    final class Coordinator: NSObject, UIDocumentPickerDelegate { // works as delegate
        let owner: DocumentPicker
        
        init(owner: DocumentPicker) {
            self.owner = owner
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            owner.isActive = false
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let imageURL = urls.first else { return }
            do {
                let imageData = try Data(contentsOf: imageURL)
                owner.image = UIImage(data: imageData).map(Background.ImageType.image) ?? .notSelected
            } catch {
                owner.image = .notSelected
            }
            owner.isActive = false
        }
    }
}
