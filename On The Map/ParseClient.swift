//
//  ParseClient.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import MapKit

class ParseClient {
    
    
    static func getStudentLocations(completionHandler: ([Student]?, NSError?) -> ()){
        let request = NSMutableURLRequest(URL: NSURL(string: ParseConfig.urlWith("classes/StudentLocation?limit=100&order=-updatedAt"))!)
        request.allHTTPHeaderFields = ParseConfig.parseHeader()
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, NSError(domain: "ParseClient", code: 400, userInfo: nil))
                return
            }
            let json = self.parseDataToJSON(data)
            guard json != nil else {
                completionHandler(nil, NSError(domain: "ParseClient", code: 400, userInfo: nil))
                return
            }
            let allStudents = AllStudents(json: json!)
            performUpdateOnMain{
                completionHandler(allStudents?.students, nil)
            }
        }
        
        task.resume()
        
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
        
        var body: NSData?
        do {
            body = try NSJSONSerialization.dataWithJSONObject(student, options: NSJSONWritingOptions.PrettyPrinted)
        }catch{
            completionHandler(NSError(domain: "ParseClient", code: 400, userInfo: nil))
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: ParseConfig.urlWith("classes/StudentLocation"))!)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = ParseConfig.parseHeader()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            performUpdateOnMain{
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                switch statusCode {
                case 200 ... 299:
                    completionHandler(nil)
                default:
                    completionHandler(NSError(domain: "ParseClient", code: 400, userInfo: nil))
                }
            }
        }
        
        task.resume()
         
    }
    
    static func parseDataToJSON(data: NSData) -> [String: AnyObject]? {
        var json: [String:AnyObject]?
        do{
            json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject]
        }catch{
            return nil
        }
        guard json != nil else {
            return nil
        }
        return json
    }
    
}
