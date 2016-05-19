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
import MapKit

class ParseClient {
    
    
    static func getStudentLocations(completionHandler: ([Student]?, NSError?) -> ()){
        
        let request = Alamofire.request(.GET, ParseConfig.urlWith("classes/StudentLocation?limit=100&order=-updatedAt"), headers: ParseConfig.parseHeader(), encoding: .JSON)
        
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
    static func postStudentLocations(mapString: String, mediaURL: String, location: CLLocationCoordinate2D,completionHandler: (NSError?) -> ()){
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        let user = appDelegate?.userController
        
        let student: [String:AnyObject] = ["uniqueKey": (user?.uniqueKey)!,
                       "firstName": (user?.firstName)!,
                       "lastName": (user?.lastName)!,
                       "mapString": mapString,
                       "mediaURL": mediaURL,
                       "latitude": location.latitude,
                       "longitude": location.longitude]
        
        let request = Alamofire.request(.POST, ParseConfig.urlWith("classes/StudentLocation"), headers: ParseConfig.parseHeader(), encoding: .JSON, parameters: student)
        
        request.validate().responseString{ response in
            switch response.result{
            case .Success:
                completionHandler(nil)
            case .Failure(let error):
                completionHandler(error)
            }
            
        }
        
    }
    
}
