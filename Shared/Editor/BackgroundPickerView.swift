//
//  BackgroundPickerView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 22.03.2021.
//

import SwiftUI

struct BackgroundPickerView: View {
    
    @Binding var backgroundType: BackgroundModel
    @Binding var backgroundPadding: CGFloat
    @State private var imagePickerPresented = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack {
                    Text("Background configuration")
                        .font(.title2)
                    Spacer()
                }
                
                Picker(selection: $backgroundType.tagValue, label: Text("What is your favorite color?")) {
                    ForEach(BackgroundModel.Tag.allCases, id: \.self) {
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
                            .optionalMaxHeight(condition: UIDevice.current.userInterfaceIdiom == .mac, value: 25)
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
                                .optionalMaxHeight(condition: UIDevice.current.userInterfaceIdiom == .mac, value: 25)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("End color")
                                .fixedSize(horizontal: true, vertical: false)
                            
                            Spacer()
                            
                            ColorPicker("End color", selection: $backgroundType.gradient.end, supportsOpacity: false)
                                .labelsHidden()
                                .optionalMaxHeight(condition: UIDevice.current.userInterfaceIdiom == .mac, value: 25)
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
                                    ImageImporter.importImage(result: result) {
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
                                TextField("radius", value: $backgroundType.blurRadius, formatter: DigitFormatter.shared)
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
                    TextField("Padding", value: $backgroundPadding, formatter: DigitFormatter.shared)
                        .multilineTextAlignment(.trailing)
                }
                .bubbled()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}
