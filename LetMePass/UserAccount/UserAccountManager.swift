//
//  UserAccountManager.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation

class UserAccountManager {
	
	static private(set) var shared = UserAccountManager()
	
	enum LoginStatus: Int {
		case loggedIn = 0
		case loggedOut
	}

	// MARK: - Public
	
	func login(user: String, password: String) {
		
	}
	
	func register(user: String, password: String) {
		
	}
}
