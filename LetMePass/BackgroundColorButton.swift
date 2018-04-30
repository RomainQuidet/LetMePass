//
//  BackgroundColorButton.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class BackgroundColorButton: UIButton {

	lazy private var backgroundColors = [UInt : UIColor]()

	// MARK : - Override
	
	override func layoutSubviews() {
		super.layoutSubviews()
		var color = self.backgroundColors[self.state.rawValue]
		color = color ?? self.backgroundColors[UIControlState.normal.rawValue]
		color = color ?? UIColor.clear
		super.backgroundColor = color
	}
	
	// MARK : - Public
	
	func setBackgroundColor(_ color: UIColor?, for state: UIControlState)
	{
		self.backgroundColors[state.rawValue] = color
	}
}
