//
//  TabBarController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/29.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentLocations()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(TabBarController.logout(_:)))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "refresh"), style: .Plain, target: self, action: #selector(TabBarController.refresh(_:)))
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: .Plain, target: self, action: #selector(TabBarController.addLocation(_:)))
        navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]
    }

    
    func logout(item: UINavigationItem){
        UdacityClient.deleteSession{ response, error in
            guard response?.session?.id != nil else {
                print(error)
                return
            }
            
            performUpdateOnMain{
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveSession(response!)
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
    
    func addLocation(item: UINavigationItem){
        performSegueWithIdentifier("post", sender: self)
    }
    
    func refresh(item: UINavigationItem){
        getStudentLocations()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func getStudentLocations(){
        var studentsModel: StudentsModel!
        studentsModel = StudentsModel.sharedInstance
        ParseClient.getStudentLocations() {students, error in
            guard let students = students else {
                performUpdateOnMain{
                    self.showAlert("Server Failure", message: "There appears to be something wrong. Please press refresh")
                }
                return
            }
            studentsModel.studentsStore = students
        }
    }
    
}
