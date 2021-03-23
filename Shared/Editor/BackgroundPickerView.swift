//
//  BackgroundPickerView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 22.03.2021.
//

import SwiftUI

struct BackgroundPickerView: View {
    
    @Binding var backgroundType: Background
    @Binding var backgroundPadding: CGFloat
    @State private var imagePickerPresented = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Background configuration")
                    .font(.title2)
                Spacer()
            }
            
            Picker(selection: $backgroundType.tagValue, label: Text("What is your favorite color?")) {
                ForEach(Background.Tag.allCases, id: \.self) {
                    Text($0.stringValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            switch backgroundType.tagValue {
            case .color:
                HStack {
                    Text("Background color")
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Spacer()
                    
                    ColorPicker("Background color", selection: $backgroundType.color, supportsOpacity: false)
                        .labelsHidden()
                        .frame(maxHeight: UIDevice.current.userInterfaceIdiom == .mac ? 25 : .infinity)
                }
                .bubbled()
                
            case .gradient:
                VStack {
                    
                    HStack {
                        Text("Start color")
                            .fixedSize(horizontal: true, vertical: false)
                        
                        Spacer()
                        
                        ColorPicker("Start color", selection: $backgroundType.gradient.start, supportsOpacity: false)
                            .labelsHidden()
                            .frame(maxHeight: UIDevice.current.userInterfaceIdiom == .mac ? 25 : .infinity)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("End color")
                            .fixedSize(horizontal: true, vertical: false)
                        
                        Spacer()
                        
                        ColorPicker("End color", selection: $backgroundType.gradient.end, supportsOpacity: false)
                            .labelsHidden()
                            .frame(maxHeight: UIDevice.current.userInterfaceIdiom == .mac ? 25 : .infinity)
                    }
                }
                .bubbled()
                
            case .image:
                VStack(spacing: 12) {
                    HStack {
                        Text("Background image")
                        Spacer()
                        backgroundType.image
                            .frame(width: TopControlsView.height, height: TopControlsView.height)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(.separator)))
                            .fileImporter(isPresented: $imagePickerPresented, allowedContentTypes: [.image], allowsMultipleSelection: false) { result in
                                importImage(result: result) {
                                    backgroundType.image = .image($0)
                                }
                            }
                            .onTapGesture {
                                imagePickerPresented = true
                            }
                    }
                    
                    if UIDevice.current.userInterfaceIdiom == .mac {
                        HStack {
                            Text("Double click to change image")
                                .fixedSize(horizontal: true, vertical: false)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Blur background")
                        Spacer()
                        Toggle("Blur background", isOn: $backgroundType.isBlurEnabled.animation())
                            .labelsHidden()
                    }
                    
                    if backgroundType.isBlurEnabled {
                        HStack {
                            Text("Radius")
                                .fixedSize()
                            TextField("radius", value: $backgroundType.blurRadius, formatter: Utils.digitFormatter)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.leading)
                    }
                }
                .bubbled()
            }
            
            HStack {
                Text("Background padding")
                    .fixedSize()
                TextField("Padding", value: $backgroundPadding, formatter: Utils.digitFormatter)
                    .multilineTextAlignment(.trailing)
            }
            .bubbled()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

extension View {
    
    func bubbled() -> some View {
        self.padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
}

func importImage(result: Result<[URL], Error>, handler: (UIImage) -> Void) {
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
