//
//  Meme.swift
//  ImagePicker
//
//  Created by Rodrigo Webler on 7/22/15.
//  Copyright (c) 2015 Rodrigo Webler. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String?
    var bottomText: String?
    
    var originalImage: UIImage
    
    var memeImage: UIImage
    
    func title() -> String {
        return topText! + "\u{2026}" + bottomText!
    }
}

func == (lhs: Meme, rhs: Meme) -> Bool {
    return lhs.memeImage == rhs.memeImage
}