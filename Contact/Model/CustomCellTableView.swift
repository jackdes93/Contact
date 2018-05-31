//
//  CustomCellTableView.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit

class CustomCellTableView: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPhone: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func setNeedsLayout() {
        imgAvatar.layer.cornerRadius = 36
    }
}
