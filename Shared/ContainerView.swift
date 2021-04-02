//
//  ContainerView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct ContainerView: View {
    
    @State private var model: EditorModel = .init()
    @State private var image: UIImage?
    @State private var stretched: UIImage?
    @State private var containerRect: CGRect = .zero
    @State private var initialSize: CGSize = .zero
    
    @State private var exportPresented = false
    
    @State private var imageFile: ImageFile?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TopControlsView(model: $model,
                                didImport: performDrop(image:))
                exportButton
            }
            .frame(height: TopControlsView.height + 16)
            
            Divider()
                .edgesIgnoringSafeArea(.all)
            
            ContentView(stretchedImage: $stretched,
                        containerRect: $containerRect,
                        initialSize: $initialSize,
                        editorModel: model,
                        performDrop: performDrop(image:))
        }
    }
    
    
    private func performDrop(image: UIImage) {
        self.image = image
        let size = CGSize(width: image.size.width * ContentView.imageSizeMultiplier,
                          height: image.size.height * ContentView.imageSizeMultiplier)
        self.stretched = image.stretchImageSides(size: size)
        
        if image.size.width > image.size.height {
            let width: CGFloat = UIDevice.current.userInterfaceIdiom == .mac ? 600 : 600
            if image.size.width > width {
                self.initialSize = .init(width: width,
                                         height: ceil(image.size.height * (width / image.size.width)))
            } else {
                self.initialSize = image.size
            }
        } else {
            self.initialSize = image.size
        }
        containerRect.origin = .zero
        containerRect.size = initialSize
    }
    
    private var exportButton: some View {
        Button {
            imageFile = exportableImage().map(ImageFile.init(image:))
            exportPresented = true
        } label: {
            Label("Export", systemImage: "square.and.arrow.up")
        }
        .buttonStyle(BubbledButtonStyle())
        .fileExporter(isPresented: $exportPresented, document: imageFile, contentType: .image) { _ in }
        .padding(.trailing)
        .buttonStyle(PlainButtonStyle())
    }
    
    private func exportableImage() -> UIImage? {
        guard let image = stretched else { return nil }
        let cropRect = ImageCropper(initialSize: initialSize, containerRect: containerRect)
                .getCropRect(image: image)
        guard let croppedImage = image.cropImage(to: cropRect) else { return nil }
        
        let background = model.background
            .frame(width: croppedImage.size.width + 2 * model.backgroundPadding,
                   height: croppedImage.size.height + 2 * model.backgroundPadding)
        
        let topNavigation = TopNavigationView(navigationType: model.navigation,
                                              imageSize: image.size,
                                              initialSize: initialSize,
                                              forImageDrawingContext: true)
            .frame(width: croppedImage.size.width, height: croppedImage.size.height)
            .clipShape(RoundedCorners(tl: model.cornerRadius, tr: model.cornerRadius, bl: 0, br: 0))
        
        let backgroundSnapshot = background.snapshot()
        let navigationSnapshot = topNavigation.snapshot()
        
        return combine(background: backgroundSnapshot,
                       image: croppedImage,
                       overlay: navigationSnapshot)
    }
    
    private func combine(background: UIImage, image: UIImage, overlay: UIImage) -> UIImage {
        let contentPoint = CGPoint(x: model.backgroundPadding,
                                   y: model.backgroundPadding)
        
        let contentRect = CGRect(origin: contentPoint, size: image.size)
        let renderer = UIGraphicsImageRenderer(size: background.size)
        let roundedRectangle = RoundedRectangle(cornerRadius: model.cornerRadius)
            .foregroundColor(.yellow)
            .frame(width: contentRect.width, height: contentRect.height)
            .snapshot()
        
        return renderer.image { context in
            background.draw(at: .zero)
            
            if model.shadowBlurRadius > 0 {
                context.cgContext.saveGState()
                context.cgContext.setShadow(offset: CGSize(width: model.shadowBlurRadius / 2, height: model.shadowBlurRadius / 2),
                                            blur: model.shadowBlurRadius,
                                            color: Color(.sRGBLinear, white: 0, opacity: 0.2).cgColor)
                roundedRectangle.draw(at: contentRect.origin)
                context.cgContext.restoreGState()
            }
            
            context.cgContext.saveGState()
            UIBezierPath(roundedRect: contentRect, cornerRadius: model.cornerRadius).addClip()
            image.draw(in: contentRect)
            context.cgContext.restoreGState()
            
            overlay.draw(in: contentRect)
        }
    }
}


struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
