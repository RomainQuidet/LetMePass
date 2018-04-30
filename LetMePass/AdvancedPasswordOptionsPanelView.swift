//
//  AdvancedPasswordOptionsPanelView.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class AdvancedPasswordOptionsPanelView: UIView {

	let lowercaseAlphabetButton = BackgroundColorButton(type: .custom)
	let uppercaseAlphabetButton = BackgroundColorButton(type: .custom)
	let digitsButton = BackgroundColorButton(type: .custom)
	let symbolsButton = BackgroundColorButton(type: .custom)
	
	let lengthControl = IntegerSelectorView()
	let indexControl = IntegerSelectorView()
	
	private let buttonWidth: CGFloat = 80
	private let buttonHeight: CGFloat = 40
	private let controlWidth: CGFloat = 110
	
	// MARK: Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		
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
		
		digitsButton.setTitle("0-9", for: .normal)
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
		
		let lengthLabel = UILabel()
		lengthLabel.text = "Length".localized()
		lengthLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(lengthLabel)
		lengthLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		lengthLabel.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 15).isActive = true
		
		lengthControl.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(lengthControl)
		lengthControl.topAnchor.constraint(equalTo: lengthLabel.bottomAnchor, constant: 2).isActive = true
		lengthControl.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		lengthControl.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
		lengthControl.widthAnchor.constraint(equalToConstant: controlWidth).isActive = true
		
		let IndexLabel = UILabel()
		IndexLabel.text = "Counter".localized()
		IndexLabel.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(IndexLabel)
		IndexLabel.leftAnchor.constraint(equalTo: self.lengthControl.rightAnchor, constant: 10).isActive = true
		IndexLabel.topAnchor.constraint(equalTo: lengthLabel.topAnchor).isActive = true
		
		indexControl.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(indexControl)
		indexControl.topAnchor.constraint(equalTo: lengthControl.topAnchor).isActive = true
		indexControl.leftAnchor.constraint(equalTo: IndexLabel.leftAnchor).isActive = true
		indexControl.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
		indexControl.widthAnchor.constraint(equalToConstant: controlWidth).isActive = true
		
		self.bottomAnchor.constraint(equalTo: indexControl.bottomAnchor).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Actions
	
	
	
	//MARK: - Private
	
	private func configureButton(_ button: BackgroundColorButton)
	{
		let font = UIFont.boldSystemFont(ofSize: 14)
		let textColor = UIColor.white
		
		button.setTitleColor(textColor, for: .normal)
		button.titleLabel?.font = font
		button.translatesAutoresizingMaskIntoConstraints = false
		button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
		button.setBackgroundColor(UIColor.blue, for: .selected)
		button.setBackgroundColor(UIColor.lightGray, for: .normal)
	}
}
