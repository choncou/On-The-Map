//
//  UdacityClient.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient{
    
    typealias sessionCompletion = (UdacityResponse?, NSError?) -> ()
    typealias userCompletion = (UdacityUser?, NSError?) -> ()
    
    static func createSession(email: String, password: String, completionHandler: sessionCompletion){
        
        let params = ["udacity":
                        ["username": email,
                         "password": password]]
        
        let headers = [
            "content-type": "application/json",
            "accept": "application/json"
        ]
        
        var body: NSData?
        do {
            body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
        }catch{
            completionHandler(nil,NSError(domain: "UdacityClient", code: 400, userInfo: nil))
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let json = self.cleanUdacityResponse(data)
            guard json != nil else {
                completionHandler(nil,NSError(domain: "UdacityClient", code: 400, userInfo: nil))
                return
            }
            
            let udacityResponse = UdacityResponse(json: json!)
            completionHandler(udacityResponse, nil)
        })
        
        dataTask.resume()
        
    }
    
    static func deleteSession(completionHandler: sessionCompletion){
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let json = self.cleanUdacityResponse(data)
            guard json != nil else {
                completionHandler(nil,NSError(domain: "UdacityClient", code: 400, userInfo: nil))
                return
            }
            
            let udacityResponse = UdacityResponse(json: json!)
            completionHandler(udacityResponse, nil)
        }
        task.resume()
        
    }
    
    static func getUserData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let sessions = appDelegate?.sessionController
        
        guard let userId = sessions?.account?.key else { return }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/"+userId)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard let data = data else {
                fatalError()
            }
            let json = self.cleanUdacityResponse(data)
            guard json != nil else {
                fatalError()
            }
            let userResponse = UdacityUser(json: json!["user"] as! [String:AnyObject])
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveUser(userResponse!)
            
        }
        task.resume()
        
    }
    
    static func cleanUdacityResponse(data: NSData) -> [String:AnyObject]? {
        let dirtyJSON = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
        let cleanJSON = dirtyJSON[dirtyJSON.startIndex.advancedBy(5)..<dirtyJSON.endIndex] //This is because Udacity API returns ")]}'/n" at the beginning of this response.
        var json: [String:AnyObject]?
        do{
            json = try NSJSONSerialization.JSONObjectWithData(cleanJSON.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.AllowFragments) as? [String : AnyObject]
        }catch{
            return nil
        }
        guard let cleaned = json else {
            return nil
        }
        return cleaned
        
    }
    
    private static func escapedParameters(parameters: [String:AnyObject]) -> String {
        if parameters.isEmpty {
            return ""
        }else{
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                let stringValue = "\(value)"
                let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                
                keyValuePairs.append(key + "=" + "\(escapedValue!)")
            }
            return "?\(keyValuePairs.joinWithSeparator("&"))"
        }
    }
    
}