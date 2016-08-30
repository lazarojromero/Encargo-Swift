//
//  AddMembersViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class AddMembersViewController: UIViewController {
    
    var currentMembers:[String] = []//empty array

    @IBOutlet var usernameTextField: DesignableTextField!
   
    @IBOutlet var boxView: DesignableView!
    
    @IBAction func addMemberDidTouch(sender: AnyObject) {
    
        if usernameTextField.text != "" {
            
            let KEY = "\(DataService.dataService.CURRENT_USER_REF)"
            
            let ref: Firebase = Firebase(url: KEY)

            currentMembers.append(usernameTextField.text!)
            
            ref.updateChildValues(["members": currentMembers])
            
            dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            boxView.animation = "shake"
            
            boxView.animate()
            
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            if snapshot.hasChild("members") {//true
                
                let temp:[String] = snapshot.value.objectForKey("members") as! [String]
                
                for x in temp {
                    
                    if x != "" {
                        
                        self.currentMembers.append(x)
                        
                    }
                    
                }
                
            }
            
            }, withCancelBlock: { error in
                
                print(error.description)
                
        })

        boxView.animation = "zoomIn"
        
        boxView.animate()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

}
