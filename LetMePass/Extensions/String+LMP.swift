//
//  String+LMP.swift
//  LetMePass
//
//  Created by Romain Quidet on 16/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation

extension String {
	func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
		return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
	}
}
