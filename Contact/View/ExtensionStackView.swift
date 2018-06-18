//
//  ExtensionStackView.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/18/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func changeBackgroundColor(color: UIColor) {
        let backgroundLayer = CAShapeLayer()
        self.layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = color.cgColor
    }
}
