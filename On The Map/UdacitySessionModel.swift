//
//  UdacitySessionModel.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Gloss

struct Account: Decodable{
    let registered: Bool?
    let key: String?
    
    init?(json: JSON) {
        registered = "registered" <~~ json
        key = "key" <~~ json
    }
}

struct Session: Decodable{
    let id: String?
    
    init?(json: JSON) {
        id = "id" <~~ json
    }
}

struct UdacityResponse: Decodable{
    let account: Account?
    let session: Session?
    
    init?(json: JSON) {
        account = "account" <~~ json
        session = "session" <~~ json
    }
}