//
//  MainViewModel.swift
//  LetMePass
//
//  Created by Romain Quidet on 15/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//
import Foundation

enum MainViewModelError: Error {
	case emptyWebsite
	case emptyLogin
	case emptyMasterPassword
	case unsupportedPlatform
}

protocol MainViewModelDelegate: class {
	func updateUI()
	func showError(error: MainViewModelError)
}

enum MainViewPanel {
	case none
	case options
	case generatedPassword
}

class MainViewModel: MainModelDelegate {
	weak var delegate: MainViewModelDelegate?
	
	private let model = MainModel()
	private var cleanMasterOnlyBlock: DispatchWorkItem?
	private var cleanGeneratedBlock: DispatchWorkItem?

	// MARK: - Lifecycle
	
	init() {
		self.model.delegate = self
	}
	
	// MARK: - Public
	
	var websitePlaceHolder: String {
		get {
			return "Website".localized()
		}
	}
	
	var loginPlaceHolder: String {
		get {
			return "Login".localized()
		}
	}
	
	var masterPasswordPlaceHolder: String {
		get {
			return "Master password".localized()
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
	
	private(set) var shouldCleanMasterPassword: Bool = true
	private(set) var shouldShowPanel: MainViewPanel = .none
	private(set) var generatedPassword: String? {
		didSet {
			if self.generatedPassword != nil,
				self.generatedPassword?.isEmpty == false {
				let cleanGeneratedBlock = DispatchWorkItem(block: { [weak self] in
					self?.generatedPassword = nil
					self?.shouldShowPanel = .none
					self?.shouldCleanMasterPassword = true
					self?.delegate?.updateUI()
				})
				DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: cleanGeneratedBlock)
				self.cleanGeneratedBlock = cleanGeneratedBlock
			}
		}
	}
	
	func masterPasswordHasBeenSet() {
		self.shouldCleanMasterPassword = false
		let cleanBlock = DispatchWorkItem(block: { [weak self] in
			self?.shouldCleanMasterPassword = true
			self?.delegate?.updateUI()
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: cleanBlock)
		self.cleanMasterOnlyBlock = cleanBlock
	}
	
	func generatePassword(with masterPassword: String?) {
		guard self.website != nil,
				self.website?.isEmpty == false else {
			self.delegate?.showError(error: .emptyWebsite)
			return
		}
		
		guard self.login != nil,
				self.login?.isEmpty == false else {
			self.delegate?.showError(error: .emptyLogin)
			return
		}
		
		guard let masterPassword = masterPassword,
				masterPassword.isEmpty == false else {
			self.delegate?.showError(error: .emptyMasterPassword)
			return
		}
		
		self.shouldCleanMasterPassword = false
		self.cleanMasterOnlyBlock?.cancel()
		self.cleanMasterOnlyBlock = nil
		self.cleanGeneratedBlock?.cancel()
		self.cleanGeneratedBlock = nil
		self.model.generatePassword(with: masterPassword)
	}
	
	func userRequestsOptionsPanel() {
		self.shouldShowPanel = .options
		self.delegate?.updateUI()
	}
	
	// MARK: - MainModelDelegate
	
	func mainModelDidFailToGeneratePassword(error: MainModelError) {
		shouldCleanMasterPassword = true
		shouldShowPanel = .none
		self.delegate?.updateUI()
		
		switch error {
		case .emptyLogin:
			self.delegate?.showError(error: .emptyLogin)
		case .emptyWebsite:
			self.delegate?.showError(error: .emptyWebsite)
		case .unsupportedPlatform:
			self.delegate?.showError(error: .unsupportedPlatform)
		}
	}
	
	func mainModelDidGeneratePassword(_ password: String) {
		self.generatedPassword = password
		shouldShowPanel = .generatedPassword
		self.delegate?.updateUI()
	}
}
