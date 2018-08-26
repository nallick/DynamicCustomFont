//
//  DynamicAttributedString.swift
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public extension NSAttributedString
{
    public convenience init(fromResource name: String, withExtension: String = "rtf", documentType: DocumentType = .rtf, bundle: Bundle = Bundle.main) throws {
        guard let url = bundle.url(forResource: name, withExtension: withExtension) else { throw NSError(domain: "File Not Found", code: NSFileNoSuchFileError, userInfo: nil) }
        let data = try Data(contentsOf: url)
        try self.init(data: data, options: [DocumentReadingOptionKey.documentType: documentType], documentAttributes: nil)
    }

    public func scaledFonts(by scale: CGFloat, mutable: Bool = false) -> NSAttributedString {
        guard scale != 1.0 else { return mutable ? NSMutableAttributedString(attributedString: self) : NSAttributedString(attributedString: self) }

        let result = NSMutableAttributedString(attributedString: self)
        result.scaleFonts(by: scale)

        return mutable ? result : NSAttributedString(attributedString: result)
    }
}

public extension NSMutableAttributedString
{
    public func scaleFonts(by scale: CGFloat) {
        guard scale != 1.0 else { return }

        self.beginEditing()

		self.enumerateAttribute(NSAttributedString.Key.font, in: NSRange(location: 0, length: self.length)) { value, range, _ in
            if let baseFont = value as? UIFont {
                let scaledFont = baseFont.withSize(baseFont.pointSize*scale)
                self.addAttribute(NSAttributedString.Key.font, value: scaledFont, range: range)
            }
        }

        self.endEditing()
    }
}
