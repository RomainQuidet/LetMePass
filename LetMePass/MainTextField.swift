//
//  MainTextField.swift
//  LetMePass
//
//  Created by Romain Quidet on 26/02/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class MainTextField: UITextField {

	enum MainTextFieldType {
		case website, login, masterPassword
	}

	private let type: MainTextFieldType
	private let imageMargin: CGFloat = 8
	private let imageTextMargin: CGFloat = 5

	init(type: MainTextFieldType, frame: CGRect) {
		self.type = type
		super.init(frame: frame)

		self.borderStyle = .line
		let leftImageView = UIImageView()
		leftImageView.contentMode = .scaleAspectFit
		switch type {
		case .website:
			leftImageView.image = #imageLiteral(resourceName: "world")
			self.keyboardType = .URL
		case .login:
			leftImageView.image = #imageLiteral(resourceName: "login")
			self.keyboardType = .emailAddress
		case .masterPassword:
			leftImageView.image = #imageLiteral(resourceName: "masterPassword")
			self.keyboardType = .default
			self.isSecureTextEntry = true
		}
		self.leftView = leftImageView
		self.leftViewMode = .always
		
		self.autocorrectionType = .no
		self.autocapitalizationType = .none
		self.spellCheckingType = .no
	}

	convenience init(type: MainTextFieldType) {
		self.init(type: type, frame: .zero)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//MARK: - Override

	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		let imageSide = self.bounds.size.height - (2 * self.imageMargin)
		let response = CGRect(x: imageMargin, y: imageMargin, width: imageSide + imageMargin, height: imageSide)
		return response
	}

}
