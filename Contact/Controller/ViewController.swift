//
//  ViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Contacts

//    MARK: Delegate View Controller
protocol ViewControllerDelegate {
    func passingData(text: String)
}

class ViewController: UIViewController {

    @IBOutlet var imgContact: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var listLabel: [UILabel]!
    @IBOutlet var listLblPhone: [UILabel]!
    
    
    var contact: CNContact!
    var delegate: ViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let contact = contact {
            imgContact.image = (contact.imageData != nil) ? UIImage(data: contact.imageData!) : UIImage(named: "imageUser.png")
            lblName.text = "\(contact.familyName) \(contact.givenName)"

            if (contact.phoneNumbers.count == listLblPhone.count) {
                for index in 0...contact.phoneNumbers.count - 1 {
                    listLabel[index].text = contact.phoneNumbers[index].label
                    listLblPhone[index].text = contact.phoneNumbers[index].value.stringValue
                }
            } else if (contact.phoneNumbers.count == 0) {
                for index in 0...listLblPhone.count - 1 {
                    listLabel[index].isHidden = true
                    listLblPhone[index].isHidden = true
                }
            } else if (contact.phoneNumbers.count < listLblPhone.count) {
                for index in 0...contact.phoneNumbers.count - 1 {
                    listLabel[index].text = contact.phoneNumbers[index].label
                    listLblPhone[index].text = contact.phoneNumbers[index].value.stringValue
                }

                for i in contact.phoneNumbers.endIndex...listLblPhone.count - 1 {
                    listLabel[i].isHidden = true
                    listLblPhone[i].isHidden = true
                }
            } else {
                for index in 0...listLblPhone.count - 1 {
                    listLabel[index].text = contact.phoneNumbers[index].label
                    listLblPhone[index].text = contact.phoneNumbers[index].value.stringValue
                }
            }
        }
        self.navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imgContact.layer.cornerRadius = imgContact.frame.width / 2
        self.imgContact.clipsToBounds = true
        lblName.textColor = .black
        lblName.font = UIFont(name: "Helvetica", size: 40)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if let editView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditView") as? EditViewController {
                editView.testString = "Jackdesy1993"
                present(editView, animated: true, completion: nil)
        }
    
    }
}


