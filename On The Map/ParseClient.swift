//
//  ParseClient.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ParseClient {
    
    
    static func getStudentLocations(completionHandler: ([Student]?, NSError?) -> ()){
        
        let request = Alamofire.request(.GET, ParseConfig.urlWith("classes/StudentLocation?limit=100"), headers: ParseConfig.parseHeader(), encoding: .JSON)
        
        request.validate().responseJSON{ response in
            switch response.result{
            case .Success(let value):
                let json = JSON(value)
                let allStudents = AllStudents(json: json.dictionaryObject!)
                completionHandler(allStudents?.students, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
            
        }
        
    }
    
}
