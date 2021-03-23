//
//  SwiftUI+Helpers.swift
//  CodeDecorator (iOS)
//
//  Created by Nikita Patskov on 23.03.2021.
//

import SwiftUI

extension View {
    
    func bubbled() -> some View {
        self.padding()
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
