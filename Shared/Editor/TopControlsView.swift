//
//  TopControlsView.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 22.03.2021.
//

import SwiftUI

struct TopControlsView: View {
    
    static var height: CGFloat {
        UIDevice.current.userInterfaceIdiom == .mac ? 30 : 44
    }
    
    @Binding var model: EditorModel
    let didImport: (UIImage) -> Void
    
    @State private var backgroundPickerPresented = false
    @State private var importImagePresented = false
    @State private var editorViewPresented = false
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                importButton
                backgroundPicker
                styleButton
            }
            .padding(.horizontal)
        }
    }
    
    private var styleButton: some View {
        Button {
            editorViewPresented = true
        } label: {
            Label("Edit", systemImage: "slider.horizontal.3")
        }
        .buttonStyle(BubbledButtonStyle())
        .popover(isPresented: $editorViewPresented) {
            EditorView(model: $model)
        }
    }
    
    private var importButton: some View {
        Button {
            importImagePresented = true
        } label: {
            Label("Import", systemImage: "square.and.arrow.down")
        }
        .buttonStyle(BubbledButtonStyle())
        .fileImporter(isPresented: $importImagePresented, allowedContentTypes: [.image], allowsMultipleSelection: false) { result in
            importImage(result: result, handler: didImport)
        }
    }
    
    @ViewBuilder private var backgroundPicker: some View {
        Button { backgroundPickerPresented = true } label: {
            model.background
                .frame(width: TopControlsView.height, height: TopControlsView.height)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color(.separator)))
        }
        .buttonStyle(PlainButtonStyle())
        .popover(isPresented: $backgroundPickerPresented) {
            BackgroundPickerView(backgroundType: $model.background,
                                 backgroundPadding: $model.backgroundPadding)
        }
    }
}
