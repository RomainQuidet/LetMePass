//
//  UserAccountLoginOrCreateViewModel.swift
//  LetMePass
//
//  Created by Romain Quidet on 13/05/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation

protocol UserAccountLoginOrCreateViewModelDelegate: class {
	func updateUI()
	func userDidLogin()
	func showError(title: String, message: String)
}

class UserAccountLoginOrCreateViewModel: UserAccountLoginOrCreateModelDelegate {
	
	weak var delegate: UserAccountLoginOrCreateViewModelDelegate?
	private let model = UserAccountLoginOrCreateModel()
	
	// MARK: - Lifecycle
	
	init() {
		self.model.delegate = self
	}
	
	// MARK: - Public
	
	var websitePlaceHolder: String {
		get {
			return UserAccountService.defaultLessPassHost
		}
	}
	
	var loginPlaceHolder: String {
		get {
			return "Login".localized()
		}
	}
	
	var masterPasswordPlaceHolder: String {
		get {
			return "Password".localized()
		}
	}
	
	var website: String? {
		get {
			return self.model.website
		}
		
		set {
			self.model.website = newValue
		}
	}
	
	var login: String? {
		get {
			return self.model.login
		}
		
		set {
			self.model.login = newValue
		}
	}
	
	func didAskForLogin(with password: String?) {
		guard let password = password else {
			self.delegate?.showError(title: "Error".localized(), message: "Please provide a password".localized())
			return
		}
		
		self.model.logUser(with: password)
	}
	
	// MARK: - Delegate
	
	func userLoginDidFinished(_ result: Bool) {
		if result == true {
			self.delegate?.userDidLogin()
		}
		else {
			self.delegate?.showError(title: "Error".localized(), message: "Oups, login did fail. Please check your credentials")
		}
	}
	
	func userRegisterDidFinished(_ result: Bool) {
		//
	}
}
