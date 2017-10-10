//
//  Store.swift
//  LoyaltyCard(Simple)
//
//  Created by Jason McCoy on 1/31/17.
//  Copyright © 2016 Jason McCoy. All rights reserved.
//

import Foundation
import ObjectMapper

class Store: Mappable {
    var lat: Double!
    var lan: Double!
    var note: String!
    var identifier: String!
    var radius: Double!
    var startDate: String!
    var endDate: String!
    var freeStampCount: Int!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        lat <- map["latitude"]
        lan <- map["longitude"]
        note <- map["note"]
        identifier <- map["identifier"]
        radius <- map["radius"]
        startDate <- map["startDate"]
        endDate <- map["endDate"]
        freeStampCount <- map["freeStampCount"]
    }
}
