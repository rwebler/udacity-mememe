//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Rodrigo Webler on 7/24/15.
//  Copyright (c) 2015 Rodrigo Webler. All rights reserved.
//

import Foundation

import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = self.appDelegate.memes[indexPath.row]
        
        // Set the cell's title and image
        cell.textLabel?.text = meme.title()
        cell.imageView?.image = meme.memeImage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetail") as! MemeDetailViewController
        detailController.meme = self.appDelegate.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}