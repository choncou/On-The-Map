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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
