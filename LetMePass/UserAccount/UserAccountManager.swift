//
//  UserAccountManager.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation

class UserAccountManager: UserAccountServiceDelegate {
	
	static let shared = UserAccountManager()
	
	enum LoginStatus: Int {
		case loggedIn = 0
		case loggedOut
	}
	private(set) var status: LoginStatus
	
	private var userAccountService = UserAccountService()
	
	//MARK: - Lifecycle
	
	private init() {
		status = .loggedOut
		userAccountService.delegate = self
	}

	// MARK: - Public
	
	func login(user: String, password: String) {
		self.userAccountService.login(user: user, password: password)
	}
	
	func register(user: String, password: String) {
		
	}
	
	//MARK: - UserAccountServiceDelegate
	
	func userAccountServiceDidFail(command: UserAccountService.ServiceCommands, error: NSError?) {
		debugPrint("user account service failure")
	}
	
	func userAccountServiceDidSucceed(command: UserAccountService.ServiceCommands, data: Any?) {
		switch command {
		case .CommandLogin:
			debugPrint("login ok !")
			status = .loggedIn
		default:
			break
		}
	}
}
