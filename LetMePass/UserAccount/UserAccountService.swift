//
//  UserAccountService.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation
import LessPassCore
import SwiftyJSON

protocol UserAccountServiceDelegate: class {
	func userAccountServiceDidFail(command: UserAccountService.ServiceCommands, error: NSError?)
	func userAccountServiceDidSucceed(command: UserAccountService.ServiceCommands, data: JSON?)
}

class UserAccountService {
	
	weak var delegate: UserAccountServiceDelegate?
	
	static let defaultLessPassHost = "https://lesspass.com"
	private var token: String?
	private let host: String
	private let urlSession: URLSession
	
	enum ServiceCommands: Int {
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
	
	init(host: String? = nil) {
		self.host = host ?? UserAccountService.defaultLessPassHost
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
		
		var request = self.serviceURLRequest(for: .CommandLogin, with: url)
		let body = ["email": user, "password": password]
		request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
		self.sendRequest(request, for: .CommandLogin)
	}
	
	func register(user: String, password: String) {
		debugPrint("register: todo")
	}
	
	func resetPassword(email: String) {
		debugPrint("resetPassword: todo")
	}
	
	func confirmResetPassword(password: String) {
		debugPrint("confirmResetPassword: todo")
	}
	
	func refreshToken(token: String) {
		debugPrint("confirmResetPassword: todo")
	}
	
	// MARK: - Profiles
	
	func create(profile: LPProfile) {
		debugPrint("create: todo")
	}
	
	func read(profileId: String) {
		debugPrint("create: todo")
	}
	
	func readAllProfiles() {
		guard let url = self.serviceURL(for: .ReadAllProfiles) else {
			return
		}
		let request = self.serviceURLRequest(for: .ReadAllProfiles, with: url)
		self.sendRequest(request, for: .ReadAllProfiles)
	}
	
	func update(profile: LPProfile, from id: String) {
		debugPrint("update: todo")
	}
	
	func delete(profileId: String) {
		debugPrint("delete: todo")
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
		
		result?.appendPathComponent("")
		return result
	}
	
	private func serviceURLRequest(for serviceCommand: ServiceCommands, with url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		switch serviceCommand {
		case .CommandLogin:
			request.httpMethod = "POST"
		case .ReadAllProfiles:
			request.httpMethod = "GET"
			if let token = self.token {
				request.setAuthorizationHeader(jwt: token)

			}
		default:
			break
		}
		return request
	}
	
	private func sendRequest(_ request: URLRequest, for command: ServiceCommands) {
		debugPrint("sending request \(request)")
		let task = self.urlSession.dataTask(with: request) { [weak self] (data, response, error) in
			if let error = error as NSError? {
				self?.warnDelegateServiceFailed(command: command, error: error)
				return
			}
			
			self?.responseHandler(data: data, command: command)
		}
		task.resume()
	}
	
	private func responseHandler(data: Data?, command: ServiceCommands) {
		switch command {
		case .CommandLogin:
			guard let data = data,
				let json = try? JSON(data: data),
				let token = json["token"].string else {
					self.warnDelegateServiceFailed(command: command, error: nil)
					return
			}
			self.token = token
			self.warnDelegateServiceSucceeded(command: command, data: json)
		case .ReadAllProfiles:
			guard let data = data,
					let json = try? JSON(data: data),
					json["results"].exists() else {
						self.warnDelegateServiceFailed(command: command, error: nil)
						return
			}
			self.warnDelegateServiceSucceeded(command: command, data: json["results"])
		default:
			break
		}
	}
	
	private func warnDelegateServiceFailed(command: UserAccountService.ServiceCommands, error: NSError?) {
		DispatchQueue.main.async { [weak self] in
			self?.delegate?.userAccountServiceDidFail(command: command, error: error)
		}
	}
	
	private func warnDelegateServiceSucceeded(command: UserAccountService.ServiceCommands, data: JSON?) {
		DispatchQueue.main.async { [weak self] in
			self?.delegate?.userAccountServiceDidSucceed(command: command, data: data)
		}
	}
}

fileprivate extension URLRequest {
	mutating func setAuthorizationHeader(jwt: String) {
		self.setValue("JWT \(jwt)", forHTTPHeaderField: "Authorization")
	}
}
