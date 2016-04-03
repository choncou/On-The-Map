//
//  TabBarController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/29.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let studentNotification = NSNotification(name: "StudentNotification", object: nil)
    var studentsStore : [Student]?{
        didSet{
            NSNotificationCenter.defaultCenter().postNotification(self.studentNotification)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: Selector("logout:"))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .Plain, target: self, action: Selector("refresh:"))
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: Selector("addLocation:"))
        navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func logout(item: UINavigationItem){
        UdacityClient.deleteSession{ response, error in
            guard response?.session?.id != nil else {
                print(error)
                return
            }
            
            performUpdateOnMain{
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveSession(response!)
                self.performSegueWithIdentifier("logout", sender: self)
            }
        }
    }
    
    func addLocation(item: UINavigationItem){
        self.performSegueWithIdentifier("post", sender: self)
    }
    
    func refresh(item: UINavigationItem){
        ParseClient.getStudentLocations{ students, error in
            guard students != nil else{
                print(error)
                return
            }
            self.studentsStore = students
        }
    }
    
    func getStudentLocations(){
        ParseClient.getStudentLocations() {students, error in
            guard let students = students else {
                print(error)
                return
            }
            self.studentsStore = students
        }
    }
    
}
