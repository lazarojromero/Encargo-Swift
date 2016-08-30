//
//  Item.swift
//  Tsk
//
//  Created by Lazaro Romero on 5/17/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import Foundation
import Firebase

class Item {
    
    //MARK: Proerties

    private var _itemRef: Firebase!
    
    private var _itemKey: String!
    
    private var _itemName: String!
    
    private var _itemAddedBy: String!
    
    private var _itemCompleted: Bool!
    
    //MARK: Methods
    
    var itemKey: String {
    
        return _itemKey
    
    }

    var itemName: String {
        
        return _itemName
        
    }
    
    var itemAddedBy: String {
        
        return _itemAddedBy
        
    }
    
    var itemCompleted: Bool {
        
        return _itemCompleted
        
    }
    
    //MARK: initialize new item
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        
        self._itemKey = key
        
        if let name = dictionary["itemName"] as? String {
            
            self._itemName = name
            
        }
        
        if let author = dictionary["itemAddedBy"] as? String {
            
            self._itemAddedBy = author
            
        } else {
            
            self._itemAddedBy = ""
        
        }
        
        if let comp = dictionary["itemCompleted"] as? Bool {
            
            self._itemCompleted = comp
            
        }
        
        self._itemRef = DataService.dataService.ITEM_REF.childByAppendingPath(self._itemKey)
        //directs item created with very own key
        
    }
    
    func toggleCompleted(complete: Bool) {
        
        if complete { //if itemCompleted == true, and toggleCompletion() is called then...
            
            _itemCompleted = false
            
        } else { //if itemCompleted == false
            
            _itemCompleted = true
            
        }
        
        _itemRef.childByAppendingPath("itemCompleted").setValue(_itemCompleted)//set property for item at ref
        
    }
    
}
