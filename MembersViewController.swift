//
//  MembersViewController.swift
//  Gro
//
//  Created by Lazaro Romero on 5/15/16.
//  Copyright © 2016 Lazaro Romero. All rights reserved.
//

import UIKit
import Firebase

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var followers = [String]()
    
    @IBAction func logoutDidTouch(sender: AnyObject) {

        DataService.dataService.CURRENT_USER_REF.unauth()//unauth() logouts current user
        //remove user's uid form storage
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        //head back to Login view
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("Login")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        
    }
    
    @IBOutlet var membersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.showLoading()
        
        membersTableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        loadMembers()
        
        membersTableView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = membersTableView.dequeueReusableCellWithIdentifier("memberCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = followers[indexPath.row]
        
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 16)
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {

            followers.removeAtIndex(indexPath.row)
            
            let KEY = "\(DataService.dataService.CURRENT_USER_REF)"
            
            let ref:Firebase = Firebase(url: KEY)
            
            ref.updateChildValues(["members": followers])
            
        }
        
        membersTableView.reloadData()
        
    }
    
    func loadMembers() {
        
        DataService.dataService.CURRENT_USER_REF.observeEventType(FEventType.Value, withBlock: { snapshot in
            
            self.followers = []
            
            if snapshot.hasChild("members") {//true
                
                let temp:[String] = snapshot.value.objectForKey("members") as! [String]
                
                for x in temp {
                    
                    if x != "" {
                        
                        self.followers.append(x)
                        
                    }
                    
                }
                
            }
            
            self.membersTableView.reloadData()
            
            }, withCancelBlock: { error in
                
                print(error.description)
                
        })
     
        view.hideLoading()
        
    }
    
}
