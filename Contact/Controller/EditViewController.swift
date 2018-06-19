//
//  EditViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/14/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Foundation
import Contacts

protocol EditDelegate {
    func reloadDataUpdate(newcontact: CNContact)
}

class EditViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var btnSave: UIBarButtonItem!
    
    var contactInfor: CNContact!
    var delegate: EditDelegate?
    var mainStack = UIStackView()
    var stackViewInfor = UIStackView()
    var subStackInfor = UIStackView()
    var stackViewPhone = UIStackView()
    var imgContact = UIImageView()
    var txtGiveName = UITextField()
    var txtFamilyName = UITextField()
    var scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        scr.contentSize.height = 2000
        return scr
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.isEnabled = false
        txtGiveName.delegate = self
        txtFamilyName.delegate = self
        
//        Init AutoLayout
        autolayoutStackViewInfo()
        autolayoutStackViewPhone()
    }

    override func viewDidDisappear(_ animated: Bool) {
        if let parentView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as? DetailViewController {
            self.delegate = parentView
            let contact = DataProvider.sharedInstance.fetchContactByIdentifier(identifier: contactInfor.identifier)
            self.delegate?.reloadDataUpdate(newcontact: contact)
        }
    }
 
    override func viewDidLayoutSubviews() {
        self.view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        if #available(iOS 11.0, *) {
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        } else {
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        }
        mainStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 240).isActive = true
        mainStack.axis = .vertical // Set hiển thị theo chiều dọc
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 10
        
    }
//    MARK: Autolayout
    private func autolayoutStackViewInfo() {
        mainStack.addArrangedSubview(stackViewInfor)
        stackViewInfor.translatesAutoresizingMaskIntoConstraints = false
        stackViewInfor.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        // Stack View setting
        stackViewInfor.axis = .horizontal
        stackViewInfor.alignment = .fill
        stackViewInfor.distribution = .fill
        stackViewInfor.spacing = 10
        
        //  Autolayout for Image
        imgContact.translatesAutoresizingMaskIntoConstraints = false
        stackViewInfor.addArrangedSubview(imgContact)
        imgContact.frame.size = CGSize(width: 120, height: 120)
        imgContact.layer.cornerRadius = imgContact.frame.width / 2
        imgContact.clipsToBounds = true
        imgContact.image = (contactInfor.thumbnailImageData != nil) ? UIImage(data: contactInfor.thumbnailImageData!, scale: 1) : #imageLiteral(resourceName: "imageUser.png")
        imgContact.contentMode = .scaleToFill
        imgContact.widthAnchor.constraint(equalTo: imgContact.heightAnchor, multiplier: 1).isActive = true
        
        
        // Stackview sub
        subStackInfor.translatesAutoresizingMaskIntoConstraints = false
        stackViewInfor.addArrangedSubview(subStackInfor)
        subStackInfor.axis = .vertical
        subStackInfor.alignment = .leading
        subStackInfor.distribution = .fillEqually
        subStackInfor.spacing = 10
        
        // GiveName textfield
        let txtGiveName = UITextField()
        txtGiveName.translatesAutoresizingMaskIntoConstraints = false
        txtGiveName.placeholder = "Give Name"
        txtGiveName.text = contactInfor.givenName
        txtGiveName.textColor = .gray
        txtGiveName.delegate = self
        subStackInfor.addArrangedSubview(txtGiveName)
        
        // FamilyName textfield
        let txtFamilyName = UITextField()
        txtFamilyName.translatesAutoresizingMaskIntoConstraints = false
        txtFamilyName.placeholder = "Family Name"
        txtFamilyName.text = contactInfor.familyName
        txtFamilyName.textColor = .gray
        txtFamilyName.delegate = self
        subStackInfor.addArrangedSubview(txtFamilyName)
        
        // Title
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 10).isActive = true
        title.text = "Phones: "
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 14)
        mainStack.addArrangedSubview(title)
    }
    
    private func autolayoutStackViewPhone() {
        mainStack.addArrangedSubview(stackViewPhone)
        stackViewPhone.translatesAutoresizingMaskIntoConstraints = false
        stackViewPhone.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
        // Stack View Phone setting
        stackViewPhone.axis = .vertical
        stackViewPhone.alignment = .fill
        stackViewPhone.distribution = .fillEqually
        stackViewPhone.spacing = 10
        let range = contactInfor.phoneNumbers.count - 1
        // Item Phone
        for i in 0...range {
            let item = UIStackView()
            stackViewPhone.addArrangedSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            item.axis = .horizontal
            item.alignment = .fill
            item.distribution = .fillEqually
            item.spacing = 10
            
            let lblValue = UILabel()
            lblValue.translatesAutoresizingMaskIntoConstraints = false
            lblValue.text = contactInfor.phoneNumbers[i].label
            item.addArrangedSubview(lblValue)
            let txtPhone = UITextField()
            txtPhone.translatesAutoresizingMaskIntoConstraints = false
            txtPhone.text = contactInfor.phoneNumbers[i].value.stringValue
            txtPhone.textColor = .blue
            item.addArrangedSubview(txtPhone)
        }
    
    }
    
//    MARK: Event Bar Button
    @IBAction func handleDone(sender: UIButton) {
        self.dismiss(animated: true) 
    }
    
    @IBAction func handleSave(sender: UIButton) {
//        let contact = CNMutableContact()
//        contact.givenName = txtFirstName.text!
//        contact.familyName = txtFamilyName.text!
//        let mainPhone = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: txtMainPhone.text!))
//        let companyPhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue: txtCompanyPhone.text!))
//        let fax = CNLabeledValue(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: txtPrivacyPhone.text!))
//        contact.phoneNumbers = [mainPhone, companyPhone, fax]
//        if DataProvider.sharedInstance.updateContact(identifierContact: self.contactInfor.identifier, newValue: contact) {
//            print("Success!")
//        } else {
//            print("Fail!")
//        }
        print(CNLabelHome)
        for index in 0...contactInfor.phoneNumbers.count-1 {
            print(contactInfor.phoneNumbers[index].label!)
        }
    }
    
//     MARK: - Navigation
    override var prefersStatusBarHidden: Bool {
        return true
    }
//    MARK: - Dimiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        btnSave.isEnabled = true
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
