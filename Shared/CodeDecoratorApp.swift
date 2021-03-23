//
//  CodeDecoratorApp.swift
//  Shared
//
//  Created by Nikita Patskov on 17.03.2021.
//

import SwiftUI
import UIKit

@main
struct CodeDecoratorApp: App {
    
        let text = """
        {
            let a = 2
        }
        """
    
    let img = UIImage(named: "testable2")!
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
        }
    }
}
