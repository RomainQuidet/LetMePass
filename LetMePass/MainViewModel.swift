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
	private var cleanBlock: BlockOperation?

	// MARK: - Lifecycle
	
	init() {
		self.model.delegate = self
	}
	
	// MARK: - Public
	
	var website: String? {
		get {
			return self.model.website
		}
		
		set {
			self.model.website = newValue
			if newValue == nil
				|| newValue?.isEmpty == true {
				self.delegate?.showError(error: .emptyWebsite)
			}
		}
	}
	
	var login: String? {
		get {
			return self.model.login
		}
		
		set {
			self.model.login = newValue
			if newValue == nil
				|| newValue?.isEmpty == true {
				self.delegate?.showError(error: .emptyLogin)
			}
		}
	}
	
	private(set) var shouldCleanMasterPassword: Bool = true
	private(set) var shouldShowPanel: MainViewPanel = .none
	private(set) var generatedPassword: String? {
		didSet {
			if self.generatedPassword != nil {
				self.cleanBlock = BlockOperation(block: { [weak self] in
					self?.generatedPassword = nil
					self?.shouldShowPanel = .none
					self?.shouldCleanMasterPassword = true
				})
				DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
					if let block = self?.cleanBlock {
						OperationQueue.main.addOperation(block)
						self?.cleanBlock = nil
					}
				}
			}
		}
	}
	
	func masterPasswordHasBeenSet(empty: Bool) {
		guard empty == false else {
			self.delegate?.showError(error: .emptyMasterPassword)
			return
		}
		self.shouldCleanMasterPassword = false
		self.cleanBlock = BlockOperation(block: { [weak self] in
			if self?.shouldShowPanel != .generatedPassword {
				self?.shouldCleanMasterPassword = true
				self?.delegate?.updateUI()
			}
		})
		DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
			if let block = self?.cleanBlock {
				OperationQueue.main.addOperation(block)
				self?.cleanBlock = nil
			}
		}
	}
	
	func generatePassword(with masterPassword: String?) {
		guard self.website != nil else {
			self.delegate?.showError(error: .emptyWebsite)
			return
		}
		
		guard self.login != nil else {
			self.delegate?.showError(error: .emptyLogin)
			return
		}
		
		guard let masterPassword = masterPassword else {
			self.delegate?.showError(error: .emptyMasterPassword)
			return
		}
		
		self.cleanBlock = nil
		self.model.generatePassword(with: masterPassword)
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
