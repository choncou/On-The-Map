//
//  ViewController.swift
//  On The Map
//
//  Created by Unathi Chonco on 2016/03/27.
//  Copyright © 2016 Unathi Chonco. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonTap(sender: UIRoundedButton) {
        guard let email = emailTextField.text, password = passwordTextField.text else { return }
        
        UdacityClient.createSession(email, password: password){ response, error in
            
            guard response?.account?.registered != nil && response?.session?.id != nil else {
                performUpdateOnMain{
                    self.showAlert("Invalid Credentials", message: "Username/Password Incorrect")
                }
                return
            }
            
            performUpdateOnMain{
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveSession(response!)
                UdacityClient.getUserData()
                self.performSegueWithIdentifier("login", sender: self)
            }
            
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Try Again", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func signUpButtonTap(sender: UIButton) {
        
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

