//
//  UserAccountLoginOrCreateModel.swift
//  LetMePass
//
//  Created by Romain Quidet on 13/05/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation

protocol UserAccountLoginOrCreateModelDelegate: class {
	func userLoginDidFinished(_ result: Bool)
	func userRegisterDidFinished(_ result: Bool)
}

class UserAccountLoginOrCreateModel {
	weak var delegate: UserAccountLoginOrCreateModelDelegate?
	var website: String?
	var login: String?
	
	func logUser(with password: String) {
		guard let login = self.login else {
			DispatchQueue.main.async { [weak self] in
				self?.delegate?.userLoginDidFinished(false)
			}
			return
		}
		UserAccountManager.shared.loginAndSync(user: login, password: password) { [weak self] in
			let result = UserAccountManager.shared.status == .loggedIn
			DispatchQueue.main.async { [weak self] in
				self?.delegate?.userLoginDidFinished(result)
			}
		}
	}
}
