//
//  AppConfigurationViewController.swift
//  LetMePass
//
//  Created by Romain Quidet on 30/04/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import UIKit
import MessageUI

class AppConfigurationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	private enum ConfigSection: Int {
		case sectionPurchase = 0
		case sectionUserAccount
		case sectionFeedback
		case sectionsNumber
	}
	
	private let configSectionCellIdentifier = "configSectionCellIdentifier"
	
	// MARK : - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.createUI()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK : - Actions
	
	@objc
	func didTapDone()
	{
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - TableViewDelegate
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return ConfigSection.sectionsNumber.rawValue
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let section = ConfigSection(rawValue: indexPath.section) else {
			return
		}
		
		switch section {
		case .sectionPurchase:
			break
		case .sectionUserAccount:
			self.showUserAccountViewController()
		case .sectionFeedback:
			self.showFeedbackForm()
		default:
			break
		}
	}
	
	// MARK: - TableViewDataSource
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let section = ConfigSection(rawValue: indexPath.section) else {
			return UITableViewCell()
		}
		
		var tmpcell = tableView.dequeueReusableCell(withIdentifier: configSectionCellIdentifier)
		if tmpcell == nil {
			tmpcell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: configSectionCellIdentifier)
		}
		let cell = tmpcell!
		
		switch section {
		case .sectionPurchase:
			cell.textLabel?.text = "TODO"
			return cell
		case .sectionUserAccount:
			cell.textLabel?.text = "User Account".localized()
			cell.detailTextLabel?.text = "Requires PRO version".localized()
			cell.accessoryType = .disclosureIndicator
			return cell
		case .sectionFeedback:
			cell.textLabel?.text = "Send feedbacks".localized()
			cell.accessoryType = .disclosureIndicator
			return cell
		case .sectionsNumber:
			return UITableViewCell()
		}
	}
	
	// MARK : - Private
	
	private func createUI()
	{
		self.title = "Configuration".localized()
		self.view.backgroundColor = UIColor.groupTableViewBackground
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
		
		let tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.delegate = self
		tableView.dataSource = self
		self.view.addSubview(tableView)
	}
	
	private func showUserAccountViewController() {
		let vc = UserAccountLoginOrCreateViewController()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
	private func showFeedbackForm() {
		guard MFMailComposeViewController.canSendMail() == true else {
			debugPrint("Error: can't send feedback email")
			return
		}
		let mailComposerVC = MFMailComposeViewController()
		let title = "LetMePass feedback".localized()
		mailComposerVC.setSubject(title)
		mailComposerVC.setToRecipients(["contact@xdappfactory.com"])
		self.present(mailComposerVC, animated: true, completion: nil)
	}
}
