//
//  DynamicFont.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//
//	For creating a UIFontTextStyle dictionary from a plist see:
//		https://useyourloaf.com/blog/using-a-custom-font-with-dynamic-type/
//
//	For the default dynamic text sizes see:
//		https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography/
//

import UIKit

public struct DynamicFont
{
    public init(named name: String, bundle: Bundle = Bundle.main) {
        guard let url = bundle.url(forResource: name, withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let styleTable = try? PropertyListDecoder().decode(BaseStyleTable.self, from: data)
            else { self.baseStyleTable = [:]; return }
        self.baseStyleTable = styleTable
    }

    public func font(forTextStyle style: UIFontTextStyle, otherwise fallback: UIFont? = nil) -> UIFont {
        guard let baseStyle = self.baseStyleTable[style.rawValue],
            let baseFont = UIFont(name: baseStyle.name, size: CGFloat(baseStyle.size))
            else { return fallback ?? UIFont.preferredFont(forTextStyle: style) }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    public func scale(forTextStyle style: UIFontTextStyle = .body) -> CGFloat {
        guard let baseStyle = self.baseStyleTable[style.rawValue],
            let baseFont = UIFont(name: baseStyle.name, size: CGFloat(baseStyle.size))
            else { return 1.0 }
        let scaledFont = UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
        return scaledFont.pointSize/CGFloat(baseStyle.size)
    }

    private struct BaseStyle: Decodable {
        let name: String
        let size: Int
    }

    private typealias BaseStyleTable = [UIFontTextStyle.RawValue: BaseStyle]

    private let baseStyleTable: BaseStyleTable
}

public extension DynamicFont
{
    public func match(font matchFont: UIFont) -> UIFont {
        let matchStyle = matchFont.textStyle
        guard matchStyle.isDynamic else { return matchFont }
        return self.font(forTextStyle: matchStyle, otherwise: matchFont)
    }

    public func matchAll(_ items: [AnyObject]) {
        for item in items {
            if let font = item.value(forKey: "font") as? UIFont {
                let matchedFont = self.match(font: font)
                item.setValue(matchedFont, forKey: "font")
            }
        }
    }
}

public extension UIFont
{
    public var textStyle: UIFontTextStyle {
        return self.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.textStyle) as? UIFontTextStyle ?? .none
    }

    public var isDynamic: Bool {
        return self.textStyle.isDynamic
    }
}

public extension UIFontTextStyle
{
	public static let none = UIFontTextStyle(rawValue: "none")

    public var isDynamic: Bool {
        return self == .body || self == .callout || self == .caption1 || self == .caption2 || self == .footnote || self == .headline || self == .subheadline || self == .largeTitle || self == .title1 || self == .title2 || self == .title3
    }
}
