//
//  ParseStudent.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Gloss

struct Student: Decodable {
    let objectId : String?
    let uniqueKey : String?
    let firstName : String?
    let lastName : String?
    let mapString : String?
    let mediaURL : String?
    let latitude : Float?
    let longitude : Float?
    
    init?(json: JSON) {
        self.objectId = "objectId" <~~ json
        
        self.uniqueKey = "uniqueKey" <~~ json
        
        self.firstName = "firstName" <~~ json
        
        self.lastName = "lastName" <~~ json
            
        self.mapString = "mapString" <~~ json
        
        self.mediaURL = "mediaURL" <~~ json
        
        self.latitude = "latitude" <~~ json
        
        self.longitude = "longitude" <~~ json
        
    }
}

struct AllStudents: Decodable {
    let students: [Student]!
    
    init?(json: JSON) {
        self.students = "results" <~~ json
    }
}