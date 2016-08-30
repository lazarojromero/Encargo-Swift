//
//  DataService.swift
//  Tsk
//
//  Created by Lazaro Romero on 5/17/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import Foundation
import Firebase

let BASE_URL = "https://ailse.firebaseio.com/"

class DataService {

    static let dataService = DataService()
    
    private var _BASE_REF = Firebase(url: BASE_URL)
    
    private var _USER_REF = Firebase(url: BASE_URL + "users") //to access user info
    
    private var _ITEM_REF = Firebase(url: BASE_URL + "items")//access item info
    
    var BASE_REF: Firebase {
        
        return _BASE_REF
        
    }
    
    var USER_REF: Firebase {
        
        return _USER_REF
        
    }
    
    var ITEM_REF: Firebase {
        
        return _ITEM_REF
        
    }

    var CURRENT_USER_REF: Firebase {
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String //grab current user uid and set as key
        
        let currentUser = Firebase(url: BASE_URL).childByAppendingPath("users").childByAppendingPath(userID)//used to access current users info with key uid
        
        return currentUser!
        
    }
    
    func createNewUser(uid: String, user: Dictionary<String, AnyObject>) {
        
        USER_REF.childByAppendingPath(uid).setValue(user)
        //a user is born, with properties passes in through Dictionary<String, AnyObject>
    }
    
    func createNewItem(item: Dictionary<String, AnyObject>) {
        
        let firebaseNewItem = ITEM_REF.childByAutoId()//parent of new item, saved and given very own ID
        
        firebaseNewItem.setValue(item)//saves to Firebase
        
        
    }
    
    
}
