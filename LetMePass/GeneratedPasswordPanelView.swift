//
//  GeneratedPasswordPanelView.swift
//  LetMePass
//
//  Created by Romain Quidet on 16/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit
import QuartzCore

class GeneratedPasswordPanelView: UIView {

	let passwordTextField = UITextField()

	private let copyButton = UIButton(type: .custom)
	private let showButon = UIButton(type: .custom)
	
	// MARK: Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.gray.cgColor
		
		copyButton.translatesAutoresizingMaskIntoConstraints = false
		copyButton.setImage(#imageLiteral(resourceName: "copy"), for: .normal)
		copyButton.backgroundColor = .blue
		copyButton.addTarget(self, action: #selector(didTapCopyButton), for: .touchUpInside)
		addSubview(self.copyButton)
		copyButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		copyButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		copyButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		copyButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		showButon.translatesAutoresizingMaskIntoConstraints = false
		showButon.setImage(#imageLiteral(resourceName: "eye"), for: .normal)
		showButon.backgroundColor = .lightGray
		showButon.addTarget(self, action: #selector(didTapShowButton), for: .touchUpInside)
		addSubview(self.showButon)
		showButon.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		showButon.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		showButon.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		showButon.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
		passwordTextField.translatesAutoresizingMaskIntoConstraints = false
		passwordTextField.isSecureTextEntry = true
		addSubview(self.passwordTextField)
		passwordTextField.leftAnchor.constraint(equalTo: copyButton.rightAnchor).isActive = true
		passwordTextField.rightAnchor.constraint(equalTo: showButon.leftAnchor).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		passwordTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Actions
	
	@objc
	func didTapShowButton() {
		passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
		DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
			self?.passwordTextField.isSecureTextEntry = true
		}
	}
	
	@objc
	func didTapCopyButton() {
		guard let password = self.passwordTextField.text else {
			return
		}
		let pasteBoard = UIPasteboard.general
		if #available(iOS 10.0, *) {
			let expireDate = Date().addingTimeInterval(15)
			pasteBoard.setItems([["public.utf8-plain-text": password]], options: [UIPasteboardOption.expirationDate: expireDate, UIPasteboardOption.localOnly: true])
		}
		else {
			pasteBoard.string = password
		}
	}
	
	
}
