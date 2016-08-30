//
//  ViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: DesignableTextField!
    
    @IBOutlet var passwordTextField: DesignableTextField!
    
    @IBAction func loginDidTouch(sender: AnyObject) {
        
         view.showLoading()
     
        if(usernameTextField.text != "" && passwordTextField.text != "") {
            
            DataService.dataService.BASE_REF.authUser(usernameTextField.text!, password: passwordTextField.text!, withCompletionBlock: { (error, authData) in
                
                if error == nil {
                    //be sure the correct uid is stored
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    //enter app
                    self.performSegueWithIdentifier("loginSuccess", sender: nil)
                    
                } else {
                    
                    self.view.hideLoading()
                    
                    self.usernameTextField.animation = "shake"
                    
                    self.passwordTextField.animation = "shake"
                    
                    self.usernameTextField.animate()
                    
                    self.passwordTextField.animate()
                    
                }
                
            })
            
            
            
        } else {
            
            usernameTextField.animation = "shake"
            
            passwordTextField.animation = "shake"
            
            usernameTextField.animate()
            
            passwordTextField.animate()
            
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
        usernameTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        passwordTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //auto login
        if ((NSUserDefaults.standardUserDefaults().valueForKey("uid")) != nil && (DataService.dataService.CURRENT_USER_REF.authData != nil)) {

            self.performSegueWithIdentifier("loginSuccess", sender: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

