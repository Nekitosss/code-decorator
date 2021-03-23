//
//  EditorView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 21.03.2021.
//

import SwiftUI

struct EditorView: View {
    
    @Binding var model: EditorModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Style")
                        .font(.title2)
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Corner radius:")
                        Spacer()
                        TextField("CornerRadius", value: $model.cornerRadius, formatter: Utils.digitFormatter)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    Divider()
                        .padding(.horizontal, 4)
                    
                    HStack {
                        Text("Shadow radius")
                        Spacer()
                        TextField("Shadow radius", value: $model.shadowBlurRadius, formatter: Utils.digitFormatter)
                            .multilineTextAlignment(.trailing)
                    }
                }
                .bubbled()
                
                VStack {
                    InlinePicker(description: "NavigationType",
                                 allCases: TopNavigation.Tag.allCases,
                                 value: $model.navigation.tag)
                    
                    if model.navigation.tag == .mac {
                        InlinePicker(description: "Navigation background",
                                     allCases: MacNavigationModel.SystemBackground.allCases,
                                     value: $model.navigation.mac.background)
                    }
                }
                .bubbled()
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground))
    }
}

protocol StringRepresentable {
    var stringValue: String { get }
}

struct InlinePicker<T: Hashable & StringRepresentable>: View {
    let description: String
    let allCases: [T]
    @Binding var value: T
    
    var body: some View {
        HStack {
            Text(UIDevice.current.userInterfaceIdiom == .mac ? description : value.stringValue)
            Spacer()
            Picker(description, selection: $value) {
                ForEach(allCases, id: \.self) {
                    Text($0.stringValue)
                }
            }
            .labelsHidden()
            .fixedSize(horizontal: true, vertical: false)
            .pickerStyle(MenuPickerStyle())
        }
    }
}

struct Utils {
    
    static let digitFormatter: Formatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        return formatter
    }()
}
