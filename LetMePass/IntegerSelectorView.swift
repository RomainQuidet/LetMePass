//
//  IntegerSelectorView.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

protocol IntegerSelectorViewDelegate: class {
	func integerSelectorViewIntegerDidUpdate(_ view: IntegerSelectorView)
}

class IntegerSelectorView: UIView {

	weak var delegate: IntegerSelectorViewDelegate?
	var integer: UInt = 0 {
		didSet {
			self.label.text = "\(self.integer)"
		}
	}
	
	var minInteger: UInt = 1
	
	private var label = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let minusButton = UIButton(type: .custom)
		minusButton.backgroundColor = .blue
		minusButton.setTitle("-", for: .normal)
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
		self.addSubview(minusButton)
		minusButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		minusButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		minusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		minusButton.widthAnchor.constraint(equalTo: minusButton.heightAnchor, multiplier: 0.75, constant: 0).isActive = true
		
		let plusButton = UIButton(type: .custom)
		plusButton.backgroundColor = .blue
		plusButton.setTitle("+", for: .normal)
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
		self.addSubview(plusButton)
		plusButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		plusButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		plusButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor, multiplier: 0.75, constant: 0).isActive = true
		
		self.integer = self.minInteger
		
		label.text = "\(self.integer)"
		label.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(label)
		label.leftAnchor.constraint(equalTo: minusButton.rightAnchor, constant: 2).isActive = true
		label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		label.rightAnchor.constraint(equalTo: plusButton.leftAnchor, constant: -2).isActive = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK : - Actions
	
	@objc
	func didTapPlus() {
		self.integer += 1
		self.delegate?.integerSelectorViewIntegerDidUpdate(self)
	}
	
	@objc
	func didTapMinus() {
		let tmp = self.integer - 1
		if tmp < self.minInteger {
			self.integer = self.minInteger
		}
		else
		{
			self.integer = tmp
		}
		self.delegate?.integerSelectorViewIntegerDidUpdate(self)
	}
}
