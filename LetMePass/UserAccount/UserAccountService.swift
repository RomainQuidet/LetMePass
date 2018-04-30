//
//  UserAccountService.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation
import LessPassCore

class UserAccountService {
	
	let defaultLessPassHost = "https://lesspass.com"
	
	private var token: String?
	private let host: String
	private let urlSession: URLSession
	
	private enum ServiceCommands: Int {
		case CommandLogin = 0
		case CommandRegister
		case CommandResetPassword
		case CommandConfirmResetPassword
		case CommandRefreshToken
		case CreateProfile
		case ReadProfile
		case ReadAllProfiles
		case UpdateProfile
		case DeleteProfile
	}
	
	// MARK: Lifecyle
	
	init(host: String) {
		self.host = host
		let configuration = URLSessionConfiguration.default
		if #available(iOS 11.0, *) {
			configuration.waitsForConnectivity = false
		}
		configuration.networkServiceType = .default
		configuration.allowsCellularAccess = true
		configuration.urlCache = nil
		configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
		
		self.urlSession = URLSession(configuration: configuration)
	}
	
	// MARK: - User
	
	func login(user: String, password: String) {
		guard let url = self.serviceURL(for: .CommandLogin) else {
			return
		}
		
		let request = URLRequest(url: url)
		
	}
	
	func register(user: String, password: String) {
		
	}
	
	func resetPassword(email: String) {
		
	}
	
	func confirmResetPassword(password: String) {
		
	}
	
	func refreshToken(token: String) {
		
	}
	
	// MARK: - Profiles
	
	func create(profile: LPProfile) {
		
	}
	
	func read(profileId: String) {
		
	}
	
	func readAllProfiles() {
		
	}
	
	func update(profile: LPProfile, from id: String) {
		
	}
	
	func delete(profileId: String) {
		
	}

	// MARK: - Private
	
	private func serviceURL(for serviceCommand: ServiceCommands) -> URL? {
		var result = URL(string: self.host)
		result?.appendPathComponent("api")
		
		switch serviceCommand {
		case .CommandLogin:
			result?.appendPathComponent("tokens")
			result?.appendPathComponent("auth")
		case .CommandRegister:
			result?.appendPathComponent("auth")
			result?.appendPathComponent("register")
		case .CommandResetPassword:
			break
		case .CommandConfirmResetPassword:
			break
		case .CommandRefreshToken:
			break
		case .CreateProfile, .ReadProfile, .ReadAllProfiles, .UpdateProfile, .DeleteProfile:
			result?.appendPathComponent("passwords")
		}
		
		if result?.lastPathComponent == "api" {
			result = nil
		}
		
		return result
	}
	
	private func sendRequest(_ request: URLRequest, for command: ServiceCommands) {
		let task = self.urlSession.dataTask(with: request) { (data, response, error) in
			//
		}
		task.resume()
	}
	
	private func responseHandler(data: Data, command: ServiceCommands) {
		
	}
}
