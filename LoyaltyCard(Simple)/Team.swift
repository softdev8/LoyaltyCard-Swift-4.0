//
//  Team.swift
//  LoyaltyCard(Simple)
//
//  Created by Jason McCoy on 2/5/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation
import ObjectMapper

class Team: Mappable {
    var name: String = ""
    var stampCount: Int = 0
    var redeemCount: Int = 0
    var photoURL: String = ""
    var key: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        stampCount <- map["stampCount"]
        redeemCount <- map["redeemCount"]
        photoURL <- map["photoURL"] 
    }
}
