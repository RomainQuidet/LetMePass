//
//  AdvancedPasswordOptionsPanelView.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class AdvancedPasswordOptionsPanelView: UIView {

	let lowercaseAlphabetButton = UIButton(type: .custom)
	let uppercaseAlphabetButton = UIButton(type: .custom)
	let digitsButton = UIButton(type: .custom)
	let symbolsButton = UIButton(type: .custom)
	
	private let buttonWidth: CGFloat = 80
	private let buttonHeight: CGFloat = 40
	
	// MARK: Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let title = UILabel(frame: .zero)
		title.text = "Advanced options".localized()
		title.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(title)
		title.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		title.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		
		lowercaseAlphabetButton.setTitle("a-z", for: .normal)
		self.configureButton(lowercaseAlphabetButton)
		
		uppercaseAlphabetButton.setTitle("A-Z", for: .normal)
		self.configureButton(uppercaseAlphabetButton)
		
		digitsButton.setTitle("A-Z", for: .normal)
		self.configureButton(digitsButton)
		
		symbolsButton.setTitle("%!@", for: .normal)
		self.configureButton(symbolsButton)
		
		let buttonStack = UIStackView(arrangedSubviews: [lowercaseAlphabetButton, uppercaseAlphabetButton, digitsButton, symbolsButton])
		buttonStack.axis = .horizontal
		buttonStack.alignment = .center
		buttonStack.distribution = .equalSpacing
		buttonStack.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(buttonStack)
		buttonStack.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5).isActive = true
		buttonStack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		buttonStack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: Private
	
	private func configureButton(_ button: UIButton)
	{
		let font = UIFont.boldSystemFont(ofSize: 14)
		let textColor = UIColor.white
		let backgroundColor = UIColor.blue
		
		button.setTitleColor(textColor, for: .normal)
		button.titleLabel?.font = font
		button.translatesAutoresizingMaskIntoConstraints = false
		button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
		button.backgroundColor = backgroundColor
	}
}
