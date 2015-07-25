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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMethod")
        navigationItem.rightBarButtonItem = editButton
    }
    
    func editMethod() {
        println("to meme editor")
        //TODO: send meme object to editor
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

