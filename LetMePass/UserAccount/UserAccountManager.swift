//
//  UserAccountManager.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserAccountManager: UserAccountServiceDelegate {
	
	static let shared = UserAccountManager()
	
	typealias UserAccountManagerCompletion = () -> Void
	enum LoginStatus: Int {
		case loggedIn = 0
		case loggedOut
	}
	private(set) var status: LoginStatus
	private(set) var profiles = [UserAccountProfile]()
	
	private var userAccountService = UserAccountService()
	private var completions = [completionsMethods: UserAccountManagerCompletion]()
	private enum completionsMethods: Int {
		case loginAndSync = 0, registerAndSync
	}
	
	//MARK: - Lifecycle
	
	private init() {
		status = .loggedOut
		userAccountService.delegate = self
	}

	// MARK: - Public
	
	func loginAndSync(user: String, password: String, completion: @escaping UserAccountManagerCompletion) {
		self.completions[.loginAndSync] = completion
		self.userAccountService.login(user: user, password: password)
	}
	
	func registerAndSync(user: String, password: String, completion: @escaping UserAccountManagerCompletion) {
		self.completions[.registerAndSync] = completion
	}
	
	func fetchProfiles() {
		self.userAccountService.readAllProfiles()
	}
	
	//MARK: - UserAccountServiceDelegate
	
	func userAccountServiceDidFail(command: UserAccountService.ServiceCommands, error: NSError?) {
		debugPrint("user account service failure")
		switch command {
		case .CommandLogin:
			if let completion = self.completions[.loginAndSync] {
				self.completions.removeValue(forKey: .loginAndSync)
				completion()
			}
		default:
			break
		}
	}
	
	func userAccountServiceDidSucceed(command: UserAccountService.ServiceCommands, data: JSON?) {
		switch command {
		case .CommandLogin:
			debugPrint("login ok !")
			status = .loggedIn
			self.fetchProfiles()
		case .ReadAllProfiles:
			self.profiles.removeAll()
			if let array = data?.array {
				for profileDic in array {
					if let profile = UserAccountProfile(json: profileDic) {
						self.profiles.append(profile)
					}
				}
			}
			debugPrint("read all profiles ok, found \(self.profiles.count) profiles")
			if let completion = self.completions[.loginAndSync] {
				self.completions.removeValue(forKey: .loginAndSync)
				completion()
			}
		default:
			break
		}
	}
}
