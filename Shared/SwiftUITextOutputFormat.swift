//
//  SwiftUITextOutputFormat.swift
//  CodeDecorator
//
//  Created by Nikita Patskov on 20.03.2021.
//

import Foundation
import Splash
import SwiftUI

/// Output format to use to generate an NSAttributedString from the
/// highlighted code. A `Theme` is used to determine what fonts and
/// colors to use for the various tokens.
public struct SwiftUITextOutputFormat: OutputFormat {
    public var theme: Theme

    public init(theme: Theme) {
        self.theme = theme
    }

    public func makeBuilder() -> Builder {
        return Builder(theme: theme)
    }
}

extension Splash.Color {
    var swiftUI: SwiftUI.Color {
        .init(self)
    }
}

public extension SwiftUITextOutputFormat {
    struct Builder: OutputBuilder {
        private let theme: Theme
        private lazy var font = theme.font.load()
        private var string = Text("")

        fileprivate init(theme: Theme) {
            self.theme = theme
        }

        public mutating func addToken(_ token: String, ofType type: TokenType) {
            let color = theme.tokenColors[type]?.swiftUI ?? SwiftUI.Color.white
            string = string + Text(token).font(font).foregroundColor(color)
        }

        public mutating func addPlainText(_ text: String) {
            string = string + Text(text).font(font).foregroundColor(theme.plainTextColor.swiftUI)
        }

        public mutating func addWhitespace(_ whitespace: String) {
            string = string + Text(whitespace)
        }

        public func build() -> Text {
            string
        }
    }
}


#if !os(Linux)


internal extension Splash.Font {
    func load() -> SwiftUI.Font {
        switch resource {
        case .system:
            return loadDefaultFont()
        case .preloaded:
            fatalError()
            
        case .path(let path):
            return load(fromPath: path) ?? loadDefaultFont()
        }
    }

    private func loadDefaultFont() -> SwiftUI.Font {
        let font: SwiftUI.Font?

        #if os(iOS)
        font = .custom("Menlo-Regular", fixedSize: CGFloat(size))
        #else
        font = load(fromPath: "/Library/Fonts/Courier New.ttf")
        #endif
        
        return font ?? .system(size: CGFloat(size))
    }

    private func load(fromPath path: String) -> SwiftUI.Font? {
        guard
            let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, path as CFString, .cfurlposixPathStyle, false),
            let provider = CGDataProvider(url: url),
            let font = CGFont(provider)
        else {
            return nil
        }

        let ctFont = CTFontCreateWithGraphicsFont(font, CGFloat(size), nil, nil)
        return Font(ctFont)
    }
}

#endif
