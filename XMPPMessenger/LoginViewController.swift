//
//  LoginViewController.swift
//  XMPPMessenger
//
//  Created by Hamza Öztürk on 16/01/2017.
//  Copyright © 2017 Hamza Öztürk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        UserDefaults.standard.set(loginTextField.text!, forKey: "userID")
        UserDefaults.standard.set(passwordTextField.text!, forKey: "userPassword")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if appDelegate.connect() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func done(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
