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
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        var editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMethod")
        
        var deleteButton = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "deleteMethod")

        navigationItem.rightBarButtonItems = [editButton, deleteButton]
    }
    
    func editMethod() {
        println("to meme editor")
        let editController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditor") as! ViewController
        editController.meme = meme
        self.navigationController!.pushViewController(editController, animated: true)
    }
    
    func deleteMethod() {
        println("delete meme")
        
        for (index, value) in enumerate(appDelegate.memes) {
            var memeValue = value as Meme
            if (memeValue == meme) {
                appDelegate.memes.removeAtIndex(index)
            }
        }
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.memeImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}

