//
//  ViewController.swift
//  LetMePass
//
//  Created by Romain Quidet on 26/02/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit
import LessPassCore

class ViewController: UIViewController {

	private let siteTextField = MainTextField(type: .website)
	private let loginTextField = MainTextField(type: .login)
	private let masterPasswordTextField = MainTextField(type: .masterPassword)
	private let sideMargin: CGFloat = 10
	private let textFieldsHeight: CGFloat = 40
	private let textFieldsVerticalMargin: CGFloat = 14
	
	let generateButton = UIButton(type: .custom)
	let profileSettingsButton = UIButton(type: .custom)
	
	private let viewModel = MainViewModel()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.createUI()
		self.createConstraints()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Actions
	
	@objc
	func didTapGenerateButton() {
		
	}
	
	@objc
	func didTapProfileSettingsButton() {
		
	}

	// MARK: - Private
	
	private func createUI() {
		self.title = "LetMePass"
		
		siteTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(siteTextField)
		loginTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(loginTextField)
		masterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(masterPasswordTextField)
		
		generateButton.translatesAutoresizingMaskIntoConstraints = false
		generateButton.setTitle("Générer", for: .normal)
		generateButton.setTitleColor(.white, for: .normal)
		generateButton.backgroundColor = .blue
		self.view.addSubview(generateButton)
		
		profileSettingsButton.translatesAutoresizingMaskIntoConstraints = false
		profileSettingsButton.setImage(#imageLiteral(resourceName: "profileSettings"), for: .normal)
		profileSettingsButton.backgroundColor = .lightGray
		self.view.addSubview(profileSettingsButton)
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
	}
}
