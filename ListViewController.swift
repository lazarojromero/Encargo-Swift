//
//  ListViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = [Item]()
    
    var currentMem = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         view.showLoading()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
   
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let item = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = item.itemName
        
        cell.detailTextLabel?.text = item.itemAddedBy
        
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 16)
        
        cell.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 12)

        toggleCellCheckbox(cell, isCompleted: item.itemCompleted)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true

    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Find the snapshot and remove the value
            let groceryItem = items[indexPath.row]
            
            let KEY = "\(DataService.dataService.ITEM_REF)/" + "\(groceryItem.itemKey)"
            
            let ref:Firebase = Firebase(url: KEY)
            
            ref.removeValue()
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the cell
        let cell = tableView.cellForRowAtIndexPath(indexPath)!
        
        // Get the associated grocery item
        let groceryItem = items[indexPath.row]
        
        // Get the new completion status
        let toggledCompletion = !groceryItem.itemCompleted
        
        // Determine whether the cell is checked and modify it's view properties
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        
        // Call updateChildValues on the grocery item's reference with just the new completed status
        let KEY = "\(DataService.dataService.ITEM_REF)/" + "\(groceryItem.itemKey)"
        
        let ref: Firebase = Firebase(url: KEY)
        
        ref.updateChildValues(["itemCompleted": !groceryItem.itemCompleted])

    }

    func toggleCellCheckbox(cell: UITableViewCell, isCompleted: Bool) {
        
        if !isCompleted {
           
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        } else {
        
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            cell.textLabel?.textColor = UIColor(hex: "28A26A")
            
            cell.detailTextLabel?.textColor = UIColor(hex: "28A26A")
        
        }
    }
    
    func loadData() {
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { (snapshot) in
            
            self.currentMem = []
            
            if snapshot.hasChild("members") {//true
                
                let temp:[String] = snapshot.value.objectForKey("members") as! [String]
                
                for x in temp {
                    
                    self.currentMem.append(x)
                    
                }
                
                self.currentMem.append(snapshot.value.objectForKey("email") as! String)
                
                DataService.dataService.ITEM_REF.observeEventType(.Value, withBlock: { (snapshot) in
                    
                    self.items = []
                    
                    if let snapshots:[FDataSnapshot] = snapshot.children.allObjects as? [FDataSnapshot] {
                        
                        for snap in snapshots {
                            
                            let temp: String = snap.value.objectForKey("itemAddedBy") as! String
                            
                            if self.currentMem.contains(temp) {
                                
                                if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                    
                                    let key = snap.key
                                    
                                    let item = Item(key: key, dictionary: postDictionary)
                                    
                                    self.items.insert(item, atIndex: 0)
                                    
                                }
                                
                            }
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                    
                    
                    }, withCancelBlock: { error in
                        
                        print(error.description)
                        
                })
                
            }
            
            }, withCancelBlock: { error in
                
                print(error.description)
                
        })
     
        view.hideLoading()
        
    }

}
    

