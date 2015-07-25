//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Rodrigo Webler on 7/25/15.
//  Copyright (c) 2015 Rodrigo Webler. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMethod")
        
        var deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteMethod")

        // add buttons to the right side of the bar
        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
        
        imageView!.image = meme.memeImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    func editMethod() {
        println("to meme editor")
        
        //call ViewController with existing meme
        let editController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! ViewController
        editController.meme = meme
        navigationController!.pushViewController(editController, animated: true)
    }
    
    func deleteMethod() {
        println("delete meme")
        
        // locate meme in array, then delete it
        for (index, value) in enumerate(appDelegate.memes) {
            var memeValue = value as Meme
            if (memeValue == meme) {
                appDelegate.memes.removeAtIndex(index)
            }
        }
        
        // go back
        if let navController = navigationController {
            navController.popViewControllerAnimated(true)
        }
        
    }
}

