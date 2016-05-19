//
//  UdacityUser.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/04/23.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Gloss

struct UdacityUser: Decodable{
    let firstName: String?
    let lastName: String?
    let uniqueKey: String?
    
    init?(json: JSON) {
        firstName = "first_name" <~~ json
        lastName = "last_name" <~~ json
        uniqueKey = "key" <~~ json
    }
}