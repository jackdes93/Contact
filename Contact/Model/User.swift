//
//  User.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import Foundation

class User {
    var userName: String = ""
    var phoneNumber: String = ""
    var nameImage: String!

    init() {
        
    }
    
    init(userName: String, phoneNumber: String, nameImage:String?) {
        self.userName = userName
        self.phoneNumber = phoneNumber
        
        if (nameImage != nil) {
            self.nameImage = nameImage!
        } else {
            self.nameImage = "imageUser.png"
        }
    }
}
