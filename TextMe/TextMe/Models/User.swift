//
//  User.swift
//  TextMe
//
//  Created by ofir sharabi on 20/04/2019.
//  Copyright © 2019 Gal Gordon. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var id = ""
    var displayName = ""
    var Email = ""
    
    
    
    // to Save IDS of Users Friends
    var friends : [String] = []

}
