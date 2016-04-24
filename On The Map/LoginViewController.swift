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
                print(error)
                return
            }
            
            performUpdateOnMain{
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveSession(response!)
                UdacityClient.getUserData()
                self.performSegueWithIdentifier("login", sender: self)
            }
            
        }
        
    }

    @IBAction func signUpButtonTap(sender: UIButton) {
        
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

