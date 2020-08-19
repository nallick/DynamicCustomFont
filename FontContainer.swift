//
//  FontContainer.swift
//
//  Copyright © 2020 Purgatory Design. Licensed under the MIT License.
//

import UIKit

public protocol FontContainer
{
	var containedFont: UIFont? { get set }
}

extension UIButton: FontContainer
{
	public var containedFont: UIFont? {
		get { self.titleLabel?.containedFont }
		set { self.titleLabel?.containedFont = newValue }
	}
}

extension UILabel: FontContainer
{
	public var containedFont: UIFont? {
		get { self.font }
		set { self.font = newValue }
	}
}

extension UITextField: FontContainer
{
	public var containedFont: UIFont? {
		get { self.font }
		set { self.font = newValue }
	}
}

extension UITextView: FontContainer
{
	public var containedFont: UIFont? {
		get { self.font }
		set { self.font = newValue }
	}
}
