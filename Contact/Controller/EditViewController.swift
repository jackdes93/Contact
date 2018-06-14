//
//  EditViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/14/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Foundation

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var testString: String = ""
    @IBOutlet var btnSave: UIBarButtonItem!
    @IBOutlet var txtFamilyName: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    @IBOutlet var txtMainPhone: UITextField!
    @IBOutlet var txtCompanyPhone: UITextField!
    @IBOutlet var txtPrivacyPhone: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       btnSave.isEnabled = false
        txtFirstName.delegate = self
        txtMainPhone.delegate = self
        txtFamilyName.delegate = self
        txtCompanyPhone.delegate = self
        txtPrivacyPhone.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//     MARK: Event Bar Button
    @IBAction func handleDone(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleSave(sender: UIButton) {
        
    }
    
//     MARK: - Navigation
    override var prefersStatusBarHidden: Bool {
        return true
    }
//    MARK: - Dimiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtFirstName.resignFirstResponder()
        txtMainPhone.resignFirstResponder()
        txtFamilyName.resignFirstResponder()
        txtCompanyPhone.resignFirstResponder()
        txtPrivacyPhone.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
