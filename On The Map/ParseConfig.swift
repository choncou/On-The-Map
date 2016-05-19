//
//  ParseConfig.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import Foundation
import Alamofire

class ParseConfig{
    private static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    private static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
//    private static let RestAPIKey = ""
    private static let baseUrl = "https://api.parse.com/1/"
    
    static func parseHeader() -> [String:String]{
        let header = ["X-Parse-Application-Id": ApplicationID, "X-Parse-REST-API-Key": RestAPIKey]
        return header
    }
    
    static func urlWith(path: String) -> String{
        let url = baseUrl+path
        return url
    }
}