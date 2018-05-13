//
//  UserAccountLoginOrCreateViewController.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit

class UserAccountLoginOrCreateViewController: UIViewController, UITextFieldDelegate,
												UserAccountLoginOrCreateViewModelDelegate {
	
	private let sideMargin: CGFloat = 10
	private let textFieldsHeight: CGFloat = 40
	private let textFieldsVerticalMargin: CGFloat = 14
	private let viewModel = UserAccountLoginOrCreateViewModel()
	private let siteTextField = MainTextField(type: .website)
	private let loginTextField = MainTextField(type: .login)
	private let passwordTextField = MainTextField(type: .masterPassword)
	private let loginButton = UIButton(type: .custom)
	private let registerButton = UIButton(type: .custom)
	
	// MARK: - Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.groupTableViewBackground
		self.createUI()
		self.createConstraints()
		self.viewModel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Actions
	
	@objc
	func didTapLoginButton() {
		self.viewModel.didAskForLogin(with: self.passwordTextField.text)
	}
	
	@objc
	func didTapRegisterButton() {
		
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
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.siteTextField {
			if self.loginTextField.text?.isEmpty == true {
				self.loginTextField.becomeFirstResponder()
				return true
			}
		}
		else if textField == self.loginTextField {
			if self.passwordTextField.text?.isEmpty == true {
				self.passwordTextField.becomeFirstResponder()
				return true
			}
		}
		
		textField.resignFirstResponder()
		return true
	}
	
	// MARK: - UserAccountLoginOrCreateViewModelDelegate
	
	func updateUI() {
		siteTextField.text = self.viewModel.website
		loginTextField.text = self.viewModel.login
	}
	
	func userDidLogin() {
		self.navigationController?.popViewController(animated: true)
	}
	
	func showError(title: String, message: String) {
		let errorVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
		errorVC.addAction(ok)
		self.present(errorVC, animated: true, completion: nil)
	}
	
	// MARK: - Private
	
	private func createUI() {
		siteTextField.placeholder = self.viewModel.websitePlaceHolder
		siteTextField.delegate = self
		siteTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(siteTextField)
		
		loginTextField.placeholder = self.viewModel.loginPlaceHolder
		loginTextField.delegate = self
		loginTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(loginTextField)
		
		passwordTextField.placeholder = self.viewModel.masterPasswordPlaceHolder
		passwordTextField.delegate = self
		passwordTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(passwordTextField)
		
		loginButton.translatesAutoresizingMaskIntoConstraints = false
		loginButton.setTitle("Log in".localized(), for: .normal)
		loginButton.setTitleColor(.white, for: .normal)
		loginButton.backgroundColor = .blue
		loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
		self.view.addSubview(loginButton)
		
		registerButton.translatesAutoresizingMaskIntoConstraints = false
		registerButton.setTitle("Register".localized(), for: .normal)
		registerButton.setTitleColor(.white, for: .normal)
		registerButton.backgroundColor = .lightGray
		registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
		self.view.addSubview(registerButton)
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
		
		passwordTextField.leftAnchor.constraint(equalTo: siteTextField.leftAnchor).isActive = true
		passwordTextField.widthAnchor.constraint(equalTo: siteTextField.widthAnchor).isActive = true
		passwordTextField.heightAnchor.constraint(equalTo: siteTextField.heightAnchor).isActive = true
		passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		
		loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
		loginButton.leftAnchor.constraint(equalTo: siteTextField.leftAnchor).isActive = true
		loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: textFieldsVerticalMargin).isActive = true
		
		registerButton.heightAnchor.constraint(equalTo: loginButton.heightAnchor).isActive = true
		registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
		registerButton.leftAnchor.constraint(equalTo: loginButton.rightAnchor).isActive = true
		registerButton.topAnchor.constraint(equalTo: loginButton.topAnchor).isActive = true
	}
}
