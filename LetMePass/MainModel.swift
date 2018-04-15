//
//  MainModel.swift
//  LetMePass
//
//  Created by Romain Quidet on 15/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//
import Foundation
import LessPassCore

enum MainModelError: Error {
	case emptyWebsite
	case emptyLogin
	case unsupportedPlatform
}

protocol MainModelDelegate: class {
	func mainModelDidFailToGeneratePassword(error: MainModelError)
	func mainModelDidGeneratePassword(_ password: String)
}


class MainModel {
	weak var delegate: MainModelDelegate?
	var website: String?
	var login: String?
	let options = LPProfileOptions()
	
	// MARK: - Public
	
	func generatePassword(with masterPassword: String) {
		guard let website = self.website else {
			self.delegate?.mainModelDidFailToGeneratePassword(error: .emptyWebsite)
			return
		}
		guard let login = self.login else {
			self.delegate?.mainModelDidFailToGeneratePassword(error: .emptyLogin)
			return
		}
		
		guard LPCore.isSupported() == true else {
			self.delegate?.mainModelDidFailToGeneratePassword(error: .unsupportedPlatform)
			return
		}
		
		let profile = LPProfile(site: website, andLogin: login)
		profile.options.uppercase = self.options.uppercase
		profile.options.lowercase = self.options.lowercase
		profile.options.symbols = self.options.symbols
		profile.options.digits = self.options.digits
		profile.options.counter = self.options.counter
		profile.options.length = self.options.length
		
		DispatchQueue.main.async { [weak self] in
			let password = LPCore.generatePassword(with: profile, andMasterPassword: masterPassword)
			self?.delegate?.mainModelDidGeneratePassword(password)
		}
	}
}
