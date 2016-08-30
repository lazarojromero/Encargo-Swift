//
//  SignupViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {
    
    @IBOutlet var dropView: DesignableView!
    
    @IBOutlet var usernameTextField: DesignableTextField!
    
    @IBOutlet var passwordTextField: DesignableTextField!
    
    @IBOutlet var confirmationTextField: DesignableTextField!
    
    @IBAction func signuDidTouch(sender: AnyObject) {
        
         view.showLoading()
        
        if(usernameTextField.text != "" && (passwordTextField.text == confirmationTextField.text)) {

            DataService.dataService.BASE_REF.createUser(usernameTextField.text!, password: passwordTextField.text!, withValueCompletionBlock: { error, result in
                
                if error == nil {//create and login user
                    
                    DataService.dataService.BASE_REF.authUser(self.usernameTextField.text!, password: self.passwordTextField.text!, withCompletionBlock: { (error, authData) in
                        
                        if error == nil {
                        
                            let user = ["provider": authData.provider!, "email": self.usernameTextField.text!, "members": [""] ]
                            //members will list email for
                            DataService.dataService.createNewUser(authData.uid, user: user as! Dictionary<String, AnyObject>)//seal the deal
                            
                            //store uid for future use
                            NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                            //enter app
                            self.performSegueWithIdentifier("signupSuccess", sender: nil)
                            
                        } else {
                            
                            self.view.hideLoading()
                            
                            self.performSegueWithIdentifier("signupFailed", sender: nil)
                            
                        }
                        
                    })

                    
                } else {
                    
                    self.view.hideLoading()
                    
                    self.performSegueWithIdentifier("signupFailed", sender: nil)
                    
                }
                
            })
            
            
        } else { //error in input information, not related to Database
            
            dropView.animation = "shake"
            
            dropView.animate()
            
            view.hideLoading()
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dropView.animation = "zoomIn"
        
        dropView.animate()
        
        usernameTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        passwordTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        confirmationTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
