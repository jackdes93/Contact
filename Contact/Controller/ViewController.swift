//
//  ViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var imgContact: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhoneNumber: UILabel!
    
    var user:User? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = user {
            imgContact.image = UIImage(contentsOfFile: "imageUser.png")
            lblName.text = user.userName
            lblPhoneNumber.text = user.phoneNumber
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var prefersStatusBarHidden: Bool {
        return true;
    }
}

