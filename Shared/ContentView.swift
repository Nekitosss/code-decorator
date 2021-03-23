//
//  ContentView.swift
//  Shared
//
//  Created by Nikita Patskov on 17.03.2021.
//

import SwiftUI
import Splash

struct ContentView: View {
    
    @Binding var stretchedImage: UIImage?
    @Binding var containerRect: CGRect
    @Binding var initialSize: CGSize
    
    let editorModel: EditorModel
    let performDrop: (UIImage) -> Void
    
    @State private var delta: DragDelta = .init()
    
    static let imageSizeMultiplier: CGFloat = 3
    
    private var totalImageSize: CGSize {
        let rect = calculatedContainerRect
        return .init(width: rect.width - rect.origin.x,
                     height: rect.height - rect.origin.y)
    }
    
    private var calculatedContainerRect: CGRect {
        // Constrain to prevent image content stretch
        let originMultiplier = (ContentView.imageSizeMultiplier - 1) / 2
        let sizeMultiplier = (ContentView.imageSizeMultiplier + 1) / 2
        
        let x = max(min(containerRect.origin.x + delta.topLeft.width + delta.bottomLeft.width, 0), originMultiplier * -initialSize.width)
        let y = max(min(containerRect.origin.y + delta.topRight.height + delta.topLeft.height, 0), originMultiplier * -initialSize.height)
        let width = min(max(initialSize.width, containerRect.size.width + delta.topRight.width + delta.bottomRight.width), initialSize.width * sizeMultiplier)
        let height = min(max(initialSize.height, containerRect.size.height + delta.bottomLeft.height + delta.bottomRight.height), initialSize.height * sizeMultiplier)
        
        return .init(x: x, y: y, width: width, height: height)
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .onDrop(of: [.image], delegate: ImageDropDelegate(handler: performDrop))
    }
    
    @ViewBuilder private var content: some View {
        if let image = self.stretchedImage {
            imageContainer(image: image)
        } else {
            Text("Drop image here")
                .padding(50)
                .background(dropDashedBackground)
        }
    }
    
    private var dropDashedBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(style: .init(lineWidth: 4, lineCap: .round, lineJoin: .round, dash: [8]))
            .foregroundColor(Color(.separator))
    }
    
    func imageContainer(image: UIImage) -> some View {
        let totalImageSize = self.totalImageSize
        let deltaWidth = delta.width
        let deltaHeight = delta.height
        let imageCenter: (GeometryProxy) -> CGPoint = {
            .init(x: ($0.size.width + deltaWidth) / 2,
                  y: ($0.size.height + deltaHeight) / 2)
        }
        let imageWidth: (GeometryProxy) -> CGFloat = {
            min($0.size.width, totalImageSize.width)
        }
        let imageHeight: (GeometryProxy) -> CGFloat = {
            min($0.size.height, totalImageSize.height)
        }
        let ratio = ImageCropper(initialSize: initialSize, containerRect: containerRect)
            .ratio(image: image)
        
        return GeometryReader { proxy in
            editorModel.background
                .frame(width: imageWidth(proxy) + 2 * editorModel.backgroundPadding * (1 / ratio),
                       height: imageHeight(proxy) + 2 * editorModel.backgroundPadding * (1 / ratio))
                .clipped()
                .position(x: imageCenter(proxy).x,
                          y: imageCenter(proxy).y)
            
            ResizableImageView(image: image, initialSize: initialSize, containerRect: calculatedContainerRect)
                .frame(width: imageWidth(proxy), height: imageHeight(proxy))
                .overlay(TopNavigationView(navigationType: editorModel.navigation, imageSize: image.size, initialSize: initialSize, forImageDrawingContext: false))
                .clipShape(RoundedRectangle(cornerRadius: editorModel.cornerRadius * image.scale * (1 / ratio)))
                .position(imageCenter(proxy))
                .shadow(radius: editorModel.backgroundPadding > 0 ? editorModel.shadowBlurRadius : 0)
            
            draggableArea
                .position(x: imageCenter(proxy).x - imageWidth(proxy) / 2,
                          y: imageCenter(proxy).y - imageHeight(proxy) / 2)
                .gesture(gesture(path: \.topLeft))
            
            draggableArea
                .position(x: imageCenter(proxy).x + imageWidth(proxy) / 2,
                          y: imageCenter(proxy).y - imageHeight(proxy) / 2)
                .gesture(gesture(path: \.topRight))
            
            draggableArea
                .position(x: imageCenter(proxy).x + imageWidth(proxy) / 2,
                          y: imageCenter(proxy).y + imageHeight(proxy) / 2)
                .gesture(gesture(path: \.bottomRight))
            
            draggableArea
                .position(x: imageCenter(proxy).x - imageWidth(proxy) / 2,
                          y: imageCenter(proxy).y + imageHeight(proxy) / 2)
                .gesture(gesture(path: \.bottomLeft))
        }
    }
    
    private var draggableArea: some View {
        Circle()
            .frame(width: 30, height: 30)
            .foregroundColor(Color.yellow.opacity(0.25))
    }
    
    private func gesture(path: WritableKeyPath<DragDelta, CGSize>) -> some Gesture {
        DragGesture()
            .onChanged {
                delta[keyPath: path] = $0.translation
            }
            .onEnded {
                delta[keyPath: path] = $0.translation
                containerRect = calculatedContainerRect
                delta[keyPath: path] = .zero
            }
    }
}
