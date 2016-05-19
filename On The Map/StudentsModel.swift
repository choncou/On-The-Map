//
//  StudentsModel.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/05/19.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class StudentsModel {
    
    static let sharedInstance = StudentsModel()
    
    let studentNotification = NSNotification(name: "StudentNotification", object: nil)
    var studentsStore : [Student]?{
        didSet{
            NSNotificationCenter.defaultCenter().postNotification(self.studentNotification)
        }
    }

}
