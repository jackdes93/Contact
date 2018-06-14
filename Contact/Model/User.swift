//
//  User.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import Foundation

struct User {
    var userName: String = ""
    var phoneNumbers = [String]()
    var nameImage: String!
    var identifier: String  = ""

    init(identifier: String, userName: String, phoneNumbers: [String], nameImage:String?) {
        self.identifier = identifier
        self.userName = userName
        for item in phoneNumbers {
            self.phoneNumbers.append(item)
        }
        
        if (nameImage != nil) {
            self.nameImage = nameImage!
        } else {
            self.nameImage = "imageUser.png"
        }
    }
}

struct Object {
    var sectionName: String!
    var sectionValue:[User]!
}
