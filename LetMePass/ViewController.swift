//
//  ViewController.swift
//  LetMePass
//
//  Created by Romain Quidet on 26/02/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, MainViewModelDelegate, IntegerSelectorViewDelegate {
	
	private let siteTextField = MainTextField(type: .website)
	private let loginTextField = MainTextField(type: .login)
	private let masterPasswordTextField = MainTextField(type: .masterPassword)
	private let sideMargin: CGFloat = 10
	private let textFieldsHeight: CGFloat = 40
	private let textFieldsVerticalMargin: CGFloat = 14
	
	private let generateButton = UIButton(type: .custom)
	private let profileSettingsButton = UIButton(type: .custom)
	
	private let generatedPasswordPanel = GeneratedPasswordPanelView()
	private var generatedPasswordPaneHeightConstraint: NSLayoutConstraint!
	private let generatedPasswordPanelHeight: CGFloat = 50
	private let advancedPasswordOptionsPanel = AdvancedPasswordOptionsPanelView()
	
	private let viewModel = MainViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.createUI()
		self.createConstraints()
		self.viewModel.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.updateUI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Actions
	
	@objc
	func didTapGenerateButton() {
		self.view.endEditing(false)
		self.viewModel.generatePassword(with: self.masterPasswordTextField.text)
	}
	
	@objc
	func didTapProfileSettingsButton() {
		self.view.endEditing(false)
		self.viewModel.userTappedOptionsPanel()
	}
	
	@objc
	func didTapAppSettingsButton() {
		let appConfigurationVC = AppConfigurationViewController()
		let navVC = UINavigationController(rootViewController: appConfigurationVC)
		navVC.modalTransitionStyle = .flipHorizontal
		self.present(navVC, animated: true, completion: nil)
	}
	
	// MARK: - UITextFieldDelegate
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField == siteTextField {
			self.viewModel.website = textField.text
		}
		else if textField == loginTextField {
			self.viewModel.login = textField.text
		}
		else if textField == masterPasswordTextField {
			self.viewModel.masterPasswordHasBeenSet()
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.siteTextField {
			if self.loginTextField.text?.isEmpty == true {
				self.loginTextField.becomeFirstResponder()
				return true
			}
		}
		else if textField == self.loginTextField {
			if self.masterPasswordTextField.text?.isEmpty == true {
				self.masterPasswordTextField.becomeFirstResponder()
				return true
			}
		}
		else if textField == self.masterPasswordTextField {
			if self.masterPasswordTextField.text?.isEmpty == false {
				self.didTapGenerateButton()
			}
		}
		
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - Password options panel
	
	@objc
	func didTapPasswordOptionsButton(button: UIButton) {
		button.isSelected = !button.isSelected
		
		if button == self.advancedPasswordOptionsPanel.lowercaseAlphabetButton {
			self.viewModel.lowerCasePasswordOption = button.isSelected
		}
		else if button == self.advancedPasswordOptionsPanel.uppercaseAlphabetButton {
			self.viewModel.upperCasePasswordOption = button.isSelected
		}
		else if button == self.advancedPasswordOptionsPanel.digitsButton {
			self.viewModel.digitsPasswordOption = button.isSelected
		}
		else if button == self.advancedPasswordOptionsPanel.symbolsButton {
			self.viewModel.symbolsPasswordOption = button.isSelected
		}
	}
	
	func integerSelectorViewIntegerDidUpdate(_ view: IntegerSelectorView) {
		if view == self.advancedPasswordOptionsPanel.lengthControl {
			self.viewModel.passwordLength = view.integer
		}
		else if view == self.advancedPasswordOptionsPanel.indexControl {
			self.viewModel.passwordCounter = view.integer
		}
	}
	
	// MARK: - MainViewModelDelegate
	
	func updateUI() {
		self.siteTextField.text = self.viewModel.website
		self.loginTextField.text = self.viewModel.login
		if self.viewModel.shouldCleanMasterPassword {
			self.masterPasswordTextField.text = nil
		}
		
		self.advancedPasswordOptionsPanel.lowercaseAlphabetButton.isSelected = self.viewModel.lowerCasePasswordOption
		self.advancedPasswordOptionsPanel.uppercaseAlphabetButton.isSelected = self.viewModel.upperCasePasswordOption
		self.advancedPasswordOptionsPanel.digitsButton.isSelected = self.viewModel.digitsPasswordOption
		self.advancedPasswordOptionsPanel.symbolsButton.isSelected = self.viewModel.symbolsPasswordOption
		
		self.advancedPasswordOptionsPanel.lengthControl.integer = self.viewModel.passwordLength
		self.advancedPasswordOptionsPanel.indexControl.integer = self.viewModel.passwordCounter
		
		if self.viewModel.panelsToShow.isEmpty {
			generateButton.isEnabled = true
			hideProfileOptionsPanel()
			hidePasswordPanel()
		}
		else {
			if self.viewModel.panelsToShow.contains(.generatedPassword) {
				generateButton.isEnabled = false
				showPasswordPanel()
			}
			else {
				generateButton.isEnabled = true
				hidePasswordPanel()
			}
			if self.viewModel.panelsToShow.contains(.passwordOptions) {
				showProfileOptionsPanel()
			}
			else {
				hideProfileOptionsPanel()
			}
		}
	}
	
	func showError(error: MainViewModelError) {
		debugPrint("got error \(error)")
		let alertActionOk = UIAlertAction(title: "OK".localized(), style: .default)
		let message: String
		switch error {
		case .emptyLogin:
			message = "Login field is empty".localized()
		case .emptyWebsite:
			message = "Website field is empty".localized()
		case .emptyMasterPassword:
			message = "Master password field is empty".localized()
		case .unsupportedPlatform:
			message = "LessPass cryptography not supported on your device".localized()
		}
		let alert = UIAlertController(title: "Warning!".localized(), message: message, preferredStyle: .alert)
		alert.addAction(alertActionOk)
		self.present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Private
	
	private func createUI() {
		self.title = "LetMePass"
		
		let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "appSettings"), style: .plain, target: self, action: #selector(didTapAppSettingsButton))
		self.navigationItem.rightBarButtonItem = settingsButton
		
		siteTextField.placeholder = self.viewModel.websitePlaceHolder
		siteTextField.delegate = self
		siteTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(siteTextField)
		
		loginTextField.placeholder = self.viewModel.loginPlaceHolder
		loginTextField.delegate = self
		loginTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(loginTextField)
		
		masterPasswordTextField.placeholder = self.viewModel.masterPasswordPlaceHolder
		masterPasswordTextField.delegate = self
		masterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(masterPasswordTextField)
		
		generateButton.translatesAutoresizingMaskIntoConstraints = false
		generateButton.setTitle("Generate".localized(), for: .normal)
		generateButton.setTitleColor(.white, for: .normal)
		generateButton.backgroundColor = .blue
		generateButton.addTarget(self, action: #selector(didTapGenerateButton), for: .touchUpInside)
		self.view.addSubview(generateButton)
		
		profileSettingsButton.translatesAutoresizingMaskIntoConstraints = false
		profileSettingsButton.setImage(#imageLiteral(resourceName: "profileSettings"), for: .normal)
		profileSettingsButton.backgroundColor = .lightGray
		profileSettingsButton.addTarget(self, action: #selector(didTapProfileSettingsButton), for: .touchUpInside)
		self.view.addSubview(profileSettingsButton)
		
		generatedPasswordPanel.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(generatedPasswordPanel)
		
		advancedPasswordOptionsPanel.translatesAutoresizingMaskIntoConstraints = false
		advancedPasswordOptionsPanel.lowercaseAlphabetButton.addTarget(self, action: #selector(didTapPasswordOptionsButton(button:)), for: .touchUpInside)
		advancedPasswordOptionsPanel.uppercaseAlphabetButton.addTarget(self, action: #selector(didTapPasswordOptionsButton(button:)), for: .touchUpInside)
		advancedPasswordOptionsPanel.digitsButton.addTarget(self, action: #selector(didTapPasswordOptionsButton(button:)), for: .touchUpInside)
		advancedPasswordOptionsPanel.symbolsButton.addTarget(self, action: #selector(didTapPasswordOptionsButton(button:)), for: .touchUpInside)
		advancedPasswordOptionsPanel.lengthControl.delegate = self
		advancedPasswordOptionsPanel.indexControl.delegate = self
		self.view.addSubview(advancedPasswordOptionsPanel)
	}

	private func createConstraints() {
		siteTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: sideMargin).isActive = true
		siteTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -sideMargin).isActive = true
		siteTextField.heightAnchor.constraint(equalToConstant: textFieldsHeight).isActive = true
		if #available(iOS 11, *) {
			siteTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
		}
		else {
			siteTextField.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 30).isActive = true
		}
		
		loginTextField.leftAnchor.constraint(equalTo: siteTextField.leftAnchor).isActive = true
		loginTextField.widthAnchor.constraint(equalTo: siteTextField.widthAnchor).isActive = true
		loginTextField.heightAnchor.constraint(equalTo: siteTextField.heightAnchor).isActive = true
		loginTextField.topAnchor.constraint(equalTo: siteTextField.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		
		masterPasswordTextField.leftAnchor.constraint(equalTo: siteTextField.leftAnchor).isActive = true
		masterPasswordTextField.widthAnchor.constraint(equalTo: siteTextField.widthAnchor).isActive = true
		masterPasswordTextField.heightAnchor.constraint(equalTo: siteTextField.heightAnchor).isActive = true
		masterPasswordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		
		generateButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		generateButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
		generateButton.leftAnchor.constraint(equalTo: siteTextField.leftAnchor).isActive = true
		generateButton.topAnchor.constraint(equalTo: masterPasswordTextField.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		
		profileSettingsButton.heightAnchor.constraint(equalTo: generateButton.heightAnchor).isActive = true
		profileSettingsButton.widthAnchor.constraint(equalTo: generateButton.heightAnchor, multiplier: 1.0).isActive = true
		profileSettingsButton.rightAnchor.constraint(equalTo: siteTextField.rightAnchor).isActive = true
		profileSettingsButton.topAnchor.constraint(equalTo: generateButton.topAnchor).isActive = true
		
		generatedPasswordPanel.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		generatedPasswordPanel.leftAnchor.constraint(equalTo: generateButton.leftAnchor).isActive = true
		generatedPasswordPaneHeightConstraint = generatedPasswordPanel.heightAnchor.constraint(equalToConstant: generatedPasswordPanelHeight)
		generatedPasswordPaneHeightConstraint.isActive = true
		generatedPasswordPanel.rightAnchor.constraint(equalTo: profileSettingsButton.rightAnchor).isActive = true
		
		advancedPasswordOptionsPanel.topAnchor.constraint(equalTo: generatedPasswordPanel.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		advancedPasswordOptionsPanel.leftAnchor.constraint(equalTo: generateButton.leftAnchor).isActive = true
		advancedPasswordOptionsPanel.rightAnchor.constraint(equalTo: profileSettingsButton.rightAnchor).isActive = true
	}
	
	private func showPasswordPanel() {
		generatedPasswordPanel.passwordTextField.text = self.viewModel.generatedPassword
		self.view.layoutIfNeeded()
		self.generatedPasswordPaneHeightConstraint.constant = self.generatedPasswordPanelHeight
		UIView.animate(withDuration: 0.2) {
			self.generatedPasswordPanel.isHidden = false
			self.view.layoutIfNeeded()
		}
	}
	
	private func hidePasswordPanel() {
		generatedPasswordPanel.passwordTextField.text = nil
		self.view.layoutIfNeeded()
		self.generatedPasswordPaneHeightConstraint.constant = 0
		UIView.animate(withDuration: 0.2) {
			self.generatedPasswordPanel.isHidden = true
			self.view.layoutIfNeeded()
		}
	}
	
	private func showProfileOptionsPanel() {
		advancedPasswordOptionsPanel.isHidden = false
	}
	
	private func hideProfileOptionsPanel() {
		advancedPasswordOptionsPanel.isHidden = true
	}
}
