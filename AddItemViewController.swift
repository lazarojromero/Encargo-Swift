//
//  AddItemViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UIViewController {
    
    var currentUsername = ""
    
    @IBOutlet var addView: DesignableView!
    
    @IBOutlet var itemTextField: DesignableTextField!
    
    @IBAction func addItemDidTouch(sender: AnyObject) {
        
        if itemTextField.text != "" {
            
            let name = itemTextField.text
            //build new item
            let newItem: Dictionary<String, AnyObject> = [
            
                "itemName": name!,
            
                "itemAddedBy": currentUsername,
            
                "itemCompleted": false
            
            ]
            
            DataService.dataService.createNewItem(newItem)
            
            dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            addView.animation = "shake"
            
            addView.animate()
            
        }
    
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTextField.keyboardAppearance = UIKeyboardAppearance.Dark
        
        addView.animation = "zoomIn"
        
        addView.animate()
        //get username of current user, and set it to currentUser so we can add it to new item
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            let currentUser = snapshot.value.objectForKey("email") as! String

            self.currentUsername = currentUser
            
            }, withCancelBlock: { error in
            
                print(error.description)
        
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
