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

struct MainOptionalPanels: OptionSet {
	let rawValue: Int
	
	static let passwordOptions = MainOptionalPanels(rawValue: 1 << 0)
	static let generatedPassword = MainOptionalPanels(rawValue: 1 << 1)
}

class MainViewModel: MainModelDelegate {
	weak var delegate: MainViewModelDelegate?
	
	private let model = MainModel()
	private var cleanMasterOnlyBlock: DispatchWorkItem?
	private var cleanGeneratedBlock: DispatchWorkItem?

	// MARK: - Lifecycle
	
	init() {
		self.model.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
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
	
	var passwordLength: UInt {
		get {
			return self.model.options.length
		}
		
		set {
			self.model.options.length = newValue
		}
	}
	
	var passwordCounter: UInt {
		get {
			return self.model.options.counter
		}
		
		set {
			self.model.options.counter = newValue
		}
	}
	
	var lowerCasePasswordOption: Bool {
		get {
			return self.model.options.lowercase
		}
		
		set {
			self.model.options.lowercase = newValue
		}
	}
	
	var upperCasePasswordOption: Bool {
		get {
			return self.model.options.uppercase
		}
		
		set {
			self.model.options.uppercase = newValue
		}
	}
	
	var digitsPasswordOption: Bool {
		get {
			return self.model.options.digits
		}
		
		set {
			self.model.options.digits = newValue
		}
	}
	
	var symbolsPasswordOption: Bool {
		get {
			return self.model.options.symbols
		}
		
		set {
			self.model.options.symbols = newValue
		}
	}
	
	private(set) var shouldCleanMasterPassword: Bool = true
	private(set) var panelsToShow: MainOptionalPanels = []
	private(set) var generatedPassword: String? {
		didSet {
			if self.generatedPassword != nil,
				self.generatedPassword?.isEmpty == false {
				let cleanGeneratedBlock = DispatchWorkItem(block: { [weak self] in
					self?.generatedPassword = nil
					self?.panelsToShow.remove(.generatedPassword)
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
	
	func userTappedOptionsPanel() {
		if self.panelsToShow.contains(.passwordOptions) {
			self.panelsToShow.remove(.passwordOptions)
		}
		else {
			self.panelsToShow.insert(.passwordOptions)
		}
		
		self.delegate?.updateUI()
	}
	
	// MARK : - App state management
	
	@objc
	func willResignActive() {
		self.generatedPassword = nil
		self.panelsToShow = []
		self.shouldCleanMasterPassword = true
		self.website = nil
		self.login = nil
		self.cleanMasterOnlyBlock?.cancel()
		self.cleanMasterOnlyBlock = nil
		self.cleanGeneratedBlock?.cancel()
		self.cleanGeneratedBlock = nil
		self.delegate?.updateUI()
	}
	
	// MARK: - MainModelDelegate
	
	func mainModelDidFailToGeneratePassword(error: MainModelError) {
		shouldCleanMasterPassword = true
		panelsToShow = []
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
		panelsToShow.insert(.generatedPassword)
		self.delegate?.updateUI()
	}
}
