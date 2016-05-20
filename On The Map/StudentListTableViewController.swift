//
//  StudentListTableViewController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/29.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(animated: Bool) {
        reloadData()
        subscribeToStudentsNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unsubscribeToStudentsNotification()
    }
    
    //MARK: Notifications
    func subscribeToStudentsNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StudentListTableViewController.studentsArrived(_:)), name: "StudentNotification", object: nil)
    }
    
    func unsubscribeToStudentsNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "StudentNotification", object: nil)
    }
    
    func studentsArrived(notification: NSNotification) {
        reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let studentsModel = StudentsModel.sharedInstance
        guard let students = studentsModel.studentsStore else{
            return 0
        }
        return students.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentsModel = StudentsModel.sharedInstance
        let cell = tableView.dequeueReusableCellWithIdentifier("studentCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(studentsModel.studentsStore![indexPath.row].firstName!) \(studentsModel.studentsStore![indexPath.row].lastName!)"
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentsModel = StudentsModel.sharedInstance
        guard let students = studentsModel.studentsStore else{
            return
        }
        UIApplication.sharedApplication().openURL(NSURL(string: students[indexPath.row].mediaURL!)!)
    }

}
