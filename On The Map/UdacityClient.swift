//
//  UdacityClient.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UdacityClient{
    
    typealias sessionCompletion = (UdacityResponse?, NSError?) -> ()
    
    static func createSession(email: String, password: String, completionHandler: sessionCompletion){
        
        let params = ["udacity":
                        ["username": email,
                         "password": password]]
        
        let request = Alamofire.request(.POST, "https://www.udacity.com/api/session", parameters: params, encoding: .JSON)
        
        request.validate().responseJSON{ response in
            switch response.result{
            case .Success(let value):
                let json = JSON(value)
                let udacityResponse = UdacityResponse(json: json.dictionaryObject!)
                completionHandler(udacityResponse, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
        
    }
    
    static func deleteSession(completionHandler: sessionCompletion){
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        var header = [String: String]()
        if let xsrfCookie = xsrfCookie {
            header = ["X-XSRF-TOKEN": xsrfCookie.value]
        }
        
        let request = Alamofire.request(.DELETE, "https://www.udacity.com/api/session", headers: header)
        
        request.validate().responseJSON{ response in
            switch response.result{
            case .Success(let value):
                let json = JSON(value)
                let udacityResponse = UdacityResponse(json: json.dictionaryObject!)
                completionHandler(udacityResponse, nil)
            case .Failure(let error):
                completionHandler(nil, error)
            }
        }
        
    }
    
}