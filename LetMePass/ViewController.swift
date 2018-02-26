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
	private let loginTextField = UITextField()
	private let masterPasswordTextField = UITextField()
	private let sideMargin: CGFloat = 10
	private let textFieldsHeight: CGFloat = 40

	override func viewDidLoad() {
		super.viewDidLoad()
		siteTextField.translatesAutoresizingMaskIntoConstraints = false
		self.view.addSubview(siteTextField)
		self.createConstraints()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: - Private

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
	}
}
