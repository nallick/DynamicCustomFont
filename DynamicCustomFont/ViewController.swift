//
//  ViewController.swift
//  DynamicCustomFont
//
//  Copyright © 2018 Purgatory Design. Licensed under the MIT License.
//

import UIKit

extension DynamicFont
{
	static let optima = DynamicFont(named: "Optima")
}

class ViewController: UIViewController
{
	@IBOutlet private var labels: [UILabel]!
	@IBOutlet private var attributedLabel: UILabel!

	private func setAttributedLabelText() {
		let bodyScale = DynamicFont.optima.scale(forTextStyle: .body)
		if let attributedText = try? NSAttributedString(fromResource: "Lincoln") {
			self.attributedLabel.attributedText = attributedText.scaledFonts(by: bodyScale)
		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        DynamicFont.optima.matchAll(self.labels)
		self.setAttributedLabelText()

		NotificationCenter.default.addObserver(self, selector: #selector(contentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }

	@objc private func contentSizeCategoryDidChange(_ notification: Notification) {
		self.setAttributedLabelText()
	}
}
