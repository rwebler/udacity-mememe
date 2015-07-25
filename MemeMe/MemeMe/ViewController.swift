//
//  ViewController.swift
//  ImagePicker
//
//  Created by Rodrigo Webler on 7/18/15.
//  Copyright (c) 2015 Rodrigo Webler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var navbar: UINavigationBar!
    
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "AvenirNextCondensed-Bold", size: 40)!,
            NSStrokeWidthAttributeName : -5.0
        ]
        
        topText.defaultTextAttributes = memeTextAttributes
        topText.text = "TOP"
        topText.textAlignment = .Center
        topText.delegate = self
        
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.text = "BOTTOM"
        bottomText.textAlignment = .Center
        bottomText.delegate = self
        
        //used when this view is called to edit an existing meme
        if (meme != nil) {
            topText.text = meme.topText
            bottomText.text = meme.bottomText
            image.image = meme.originalImage
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        shareButton.enabled = image.image != nil
        
        // when editing existing memes, hide tabbar
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        //create the meme structure
        let meme = save()
        
        //call the Activity View
        let activityVC = UIActivityViewController(activityItems: [meme.memeImage], applicationActivities: nil)
        
        //after meme is shared, return to the Sent Memes view
        activityVC.completionWithItemsHandler = {(activityType, completed:Bool, returnedItems:[AnyObject]!, error:NSError!) in
            if completed {
                println("complete \(activityType)")
                self.dismissViewControllerAnimated(true, completion: nil);
            }
        }
        
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotifications() {
        println("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        println("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //move view up when keyboard appears
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("textFieldShouldReturn")
        textField.resignFirstResponder()
        
        return true;
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        println("textFieldDidBeginEditing")
        if(textField == self.bottomText) {
            //move view up when bottom text is being edited
            subscribeToKeyboardNotifications()
            if (textField.text == "BOTTOM") {
                textField.text = ""
            }
        } else {
            if (textField.text == "TOP") {
                textField.text = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        println("textFieldDidEndEditing")
        if(textField == self.bottomText) {
            unsubscribeFromKeyboardNotifications()
            if (textField.text == "") {
                textField.text = "BOTTOM"
            }
        } else {
            if (textField.text == "") {
                textField.text = "TOP"
            }
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        // hide extra screen elements
        navbar.hidden = true
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // re-display extra screen elements
        toolbar.hidden = false
        navbar.hidden = false
        
        return memedImage
    }
    
    func save() -> Meme {
        //Create the meme
        var meme = Meme( topText: topText.text!, bottomText: bottomText.text!, originalImage:
            image.image!, memeImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        println(appDelegate.memes.count)
        
        return meme
    }
    
    @IBAction func dismiss(sender: UIBarButtonItem) {
        //used by the Cancel button
        dismissViewControllerAnimated(true, completion: nil);
    }
    
}



