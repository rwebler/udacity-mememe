//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Rodrigo Webler on 7/25/15.
//  Copyright (c) 2015 Rodrigo Webler. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    func load(meme: Meme) {
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "AvenirNextCondensed-Bold", size: 20)!,
            NSStrokeWidthAttributeName : -2.5
        ]
        
        let topString = NSAttributedString(string: meme.topText!, attributes: memeTextAttributes)
        
        topLabel.attributedText = topString
        topLabel.textAlignment = .Center
        
        let bottomString = NSAttributedString(string: meme.bottomText!, attributes: memeTextAttributes)
        
        bottomLabel.attributedText = bottomString
        bottomLabel.textAlignment = .Center
        
        memeImageView.image = meme.originalImage
        
    }
    
}
