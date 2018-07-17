//
//  ExtensionStackView.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/18/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    var productName: String? {
        return object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}

extension UIStackView {
    func changeBackgroundColor(color: UIColor) {
        let backgroundLayer = CAShapeLayer()
        self.layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = color.cgColor
    }
}

// MARK: Extension
extension String {
    // Remove character not digitNumber
    func trimmedNumber() -> String {
        let digitSet = CharacterSet.decimalDigits
        return String(self.unicodeScalars.filter { digitSet.contains($0) })
    }
    
    func firstCharacterOfString() -> String {
        return String(self[self.startIndex]).uppercased()
    }
    
    mutating func replaceString(string:String, at startIndex:String.Index, ofSetBy: Int) -> String {
        let range = startIndex..<self.index(startIndex, offsetBy: ofSetBy)
        self.replaceSubrange(range, with: string)
        return self
    }
    
    // Return original format phone number VietNam not Country code
    mutating func recoverOriginalPhoneFormat() -> String {
        if String(self[..<self.index(self.startIndex, offsetBy: 3)]) == "+84" {
            return self.replaceString(string: "0", at: self.startIndex, ofSetBy: 3)
        }
        return self
    }
    
    mutating func groupingNetworkByHeaderNumber() -> String {
        let strCheck = self.recoverOriginalPhoneFormat().trimmedNumber()
        var headerNumber = ""
        
        if strCheck.count == 10 {
            headerNumber = String(strCheck[..<strCheck.index(strCheck.startIndex, offsetBy: 3)])
        } else {
            headerNumber = String(strCheck[..<strCheck.index(strCheck.startIndex, offsetBy: 4)])
        }
        
        switch headerNumber {
            case "089", "090", "093", "0120", "0121", "0122", "0126", "0128":
                return "MOBIFONE"
            case "088", "091", "094", "0123", "0124", "0125", "0127", "0129":
                return "VINAPHONE"
            case "086", "096", "097", "098", "0162", "0163", "0164", "0165", "0166", "0167", "0168", "0169":
                return "VIETTEL"
            case "092", "0186", "0188":
                return "VIETNAMMOBILE"
            case "099", "0199":
                return "GMOBILE"
            default:
                return "OTHER"
        }
    }
}


