//
//  ContainerView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct EditorModel: Equatable {
    var backgroundPadding: CGFloat = 24
    var shadowBlurRadius: CGFloat = 8
    var cornerRadius: CGFloat = 8
    var navigation: TopNavigation = TopNavigation()
    var background: Background = .init()
}

struct Background: Equatable, View {
    var color: Color = .white
    var gradient: Gradient = .init(start: .purple, end: .yellow)
    var image: ImageType = .notSelected
    var blurRadius: CGFloat = 12
    var isBlurEnabled: Bool = false
    
    var tagValue: Tag = .color
    
    enum ImageType: Equatable, View {
        case notSelected
        case image(UIImage)
        
        var body: some View {
            switch self {
            case let .image(image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .notSelected:
                Color.white
            }
        }
    }
    
    enum Tag: Equatable, CaseIterable {
        case color
        case gradient
        case image
        
        var stringValue: String {
            switch self {
            case .color:
                return "Color"
            case .gradient:
                return "Gradient"
            case .image:
                return "Image"
            }
        }
    }
    
    struct Gradient: Equatable {
        var start: Color
        var end: Color
        let startPoint: UnitPoint = .topLeading
        let endPoint: UnitPoint = .bottomTrailing
        
        var swiftUI: some View {
            LinearGradient(gradient: SwiftUI.Gradient(colors: [start, end]), startPoint: startPoint, endPoint: endPoint)
        }
    }
    
    var body: some View {
        switch tagValue {
        case .color:
            color
        case .gradient:
            gradient.swiftUI
        case .image:
            image
                .blur(radius: isBlurEnabled ? blurRadius : 0)
        }
    }
}

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

struct BubbledButtonStyle: ButtonStyle {
    
    static var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .mac ? 14 : 20
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.system(size: BubbledButtonStyle.fontSize))
            .foregroundColor(configuration.isPressed ? Color.blue.opacity(0.5) : .blue)
            .frame(maxHeight: TopControlsView.height)
            .padding(.horizontal)
            .overlay(Capsule().stroke(Color(.separator)))
    }
    
}

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

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

extension UIImage {
    
    func addingShadow(blur:
                        CGFloat = 1, shadowColor: UIColor = UIColor(white: 0, alpha: 1), offset: CGSize = CGSize(width: 1, height: 1) ) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + 2 * blur, height: size.height + 2 * blur), false, 0)
        let context = UIGraphicsGetCurrentContext()!

        context.setShadow(offset: offset, blur: blur, color: shadowColor.cgColor)
        draw(in: CGRect(x: blur - offset.width / 2, y: blur - offset.height / 2, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()

        return image
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView()
    }
}
