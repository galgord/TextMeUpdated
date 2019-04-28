//
//  File.swift
//  TextMe
//
//  Created by Gal Gordon on 28/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit

extension UIColor{
    
    static var primaryDark : UIColor{
        get{
            return UIColor(red: 38, green: 191, blue: 191)
        }
    }
    
    convenience init(red: Int,green:Int,blue:Int,a:CGFloat = 1.0) {
        self.init(red:CGFloat(red)/255.0, green:CGFloat(green)/255.0, blue:CGFloat(blue)/255.0, alpha : a)
    }
}
