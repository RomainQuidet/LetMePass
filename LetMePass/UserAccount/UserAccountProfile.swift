//
//  UserAccountProfile.swift
//  LetMePass
//
//  Created by Romain Quidet on 12/05/2018.
//  Copyright © 2018 XDAppfactory. All rights reserved.
//

import Foundation
import LessPassCore
import SwiftyJSON

struct UserAccountProfile {
	private(set) var id: String
	private(set) var profile: LPProfile
	var created: Date?
	var modified: Date?
	
	
	init(id: String, profile: LPProfile) {
		self.id = id
		self.profile = profile
	}
	
	init?(json: JSON) {
		guard let dic = json.dictionary,
			let id = dic["id"]?.string,
			let login = dic["login"]?.string,
			let site = dic["site"]?.string else {
				return nil
		}
		let profile = LPProfile(site: site, andLogin: login)
		if let lowerCase = dic["lowercase"]?.bool {
			profile.options.lowercase = lowerCase
		}
		if let upperCase = dic["uppercase"]?.bool {
			profile.options.uppercase = upperCase
		}
		if let symbols = dic["symbols"]?.bool {
			profile.options.symbols = symbols
		}
		if let numbers = dic["numbers"]?.bool {
			profile.options.digits = numbers
		}
		if let counter = dic["counter"]?.number {
			profile.options.counter = counter.uintValue
		}
		if let length = dic["length"]?.number {
			profile.options.length = length.uintValue
		}
		
		self.init(id: id, profile: profile)
	}
}
