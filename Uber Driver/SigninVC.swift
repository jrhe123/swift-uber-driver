//
//  SigninVC.swift
//  Uber Driver
//
//  Created by Jiarong He on 2017-10-21.
//  Copyright © 2017 Jiarong He. All rights reserved.
//

import UIKit
import FirebaseAuth

class SigninVC: UIViewController {

    private let DRIVER_SEGUE = "DriverSegue"
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: Any) {
        
        if EmailTextField.text != "" && PasswordTextField.text != "" {
            
            AuthProvider.Instance.login(withEmail: EmailTextField.text!, password: PasswordTextField.text!, loginHandler: { (message) in
               
                if message != nil{
                    self.alerTheUser(title: "Problem With Authentication", message: message!);
                }else{
                    
                    UberHandler.Instance.driver = self.EmailTextField.text!;
                    self.EmailTextField.text = "";
                    self.PasswordTextField.text = "";
                    
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: self);
                }
            });
        } else {
            self.alerTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
    }

    @IBAction func signin(_ sender: Any) {
        
        if EmailTextField.text != "" && PasswordTextField.text != "" {
            
            AuthProvider.Instance.signup(withEmail: EmailTextField.text!, password: PasswordTextField.text!, loginHandler: { (message) in
                
                if message != nil {
                    self.alerTheUser(title: "Problem With Creating A New User", message: message!)
                }else{
                    
                    UberHandler.Instance.driver = self.EmailTextField.text!;
                    self.EmailTextField.text = "";
                    self.PasswordTextField.text = "";
                    
                    self.performSegue(withIdentifier: self.DRIVER_SEGUE, sender: self);
                }
                
            })
        } else {
            self.alerTheUser(title: "Email And Password Are Required", message: "Please enter email and password in the text fields");
        }
    }
    
    private func alerTheUser(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
}// class











