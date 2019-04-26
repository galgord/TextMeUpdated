//
//  Colors.swift
//  TextMe
//
//  Created by ofir sharabi on 26/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import UIKit

// Managing App Dominant Colors Here
extension UIColor {
    
    static let primaryDarkColor = UIColor(red: 38, green: 191, Blue: 191, a: 1)

    convenience init(red: Int,green: Int,Blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0 , blue: CGFloat(Blue) / 255.0, alpha: a)
    }
}
