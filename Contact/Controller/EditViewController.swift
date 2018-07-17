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
    // MARK: Definded variable
    var contactInfor: CNContact!
    var delegate: EditDelegate?
    var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    var stackViewInfor: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    var subStackInfor: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    var stackViewPhone: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    var imgContact: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.frame.size = CGSize(width: 120, height: 120)
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    var txtGiveName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Give Name"
        textField.textColor = .gray
        return textField
    }()
    
    var txtFamilyName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Family Name"
        textField.textColor = .gray
        return textField
    }()
    
    var scrollView: UIScrollView = {
        let scr = UIScrollView()
        scr.translatesAutoresizingMaskIntoConstraints = false
        scr.contentSize.height = 900
        return scr
    }()
    
    var lblTitle: UILabel = {
        let lbT = UILabel()
        lbT.translatesAutoresizingMaskIntoConstraints = false
        lbT.text = "Phones: "
        lbT.textColor = .black
        lbT.font = UIFont.boldSystemFont(ofSize: 14)
        return lbT
    }()
    
    var listLabel = [UILabel]()
    var listTextFieldPhone = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.isEnabled = false
        txtGiveName.delegate = self
        txtFamilyName.delegate = self
        // Init AutoLayout
        autoLayoutWithScrollView()
        autolayoutStackViewInfo()
        autolayoutStackViewPhone()
    }

    override func viewDidDisappear(_ animated: Bool) {
       
    }
 
    override func viewDidLayoutSubviews() {
        self.view.addSubview(mainStack)
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        if #available(iOS 11.0, *) {
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        } else {
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        }
        mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
//    MARK: Autolayout
    private func autoLayoutWithScrollView() {
        mainStack.addSubview(scrollView)
        scrollView.topAnchor.constraint(equalTo: mainStack.topAnchor, constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 80).isActive = true

    }
    
    private func autolayoutStackViewInfo() {
        scrollView.addSubview(stackViewInfor)
        stackViewInfor.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
        stackViewInfor.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        stackViewInfor.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackViewInfor.heightAnchor.constraint(equalToConstant: 120).isActive = true

        //  Autolayout for Image
        stackViewInfor.addArrangedSubview(imgContact)
        imgContact.image = (contactInfor.thumbnailImageData != nil) ? UIImage(data: contactInfor.thumbnailImageData!, scale: 1) : #imageLiteral(resourceName: "imageUser.png")
        imgContact.widthAnchor.constraint(equalTo: imgContact.heightAnchor, multiplier: 1).isActive = true
        
        // Stackview sub
        stackViewInfor.addArrangedSubview(subStackInfor)
        
        // GiveName textfield
        subStackInfor.addArrangedSubview(txtGiveName)
        txtGiveName.text = contactInfor.givenName
        txtGiveName.delegate = self
        
        // FamilyName textfield
        subStackInfor.addArrangedSubview(txtFamilyName)
        txtFamilyName.text = contactInfor.familyName
        txtFamilyName.delegate = self
        
        // Title
        lblTitle.heightAnchor.constraint(equalToConstant: 10).isActive = true
        scrollView.addSubview(lblTitle)
        lblTitle.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        lblTitle.topAnchor.constraint(equalTo: stackViewInfor.topAnchor, constant: 140).isActive = true
    }
    
    private func autolayoutStackViewPhone() {
        scrollView.addSubview(stackViewPhone)
        stackViewPhone.topAnchor.constraint(equalTo: lblTitle.topAnchor, constant: 10).isActive = true
        stackViewPhone.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        stackViewPhone.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
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
            txtPhone.delegate = self
            
            listLabel.append(lblValue)
            listTextFieldPhone.append(txtPhone)
        }
    
    }
    
//    MARK: Event Bar Button
    @IBAction func handleDone(sender: UIButton) {
        self.dismiss(animated: true) {
            let contact = DataProvider.sharedInstance.fetchContactByIdentifier(identifier: self.contactInfor.identifier)
            self.delegate?.reloadDataUpdate(newcontact: contact)
        }
       
    }
    
    @IBAction func handleSave(sender: UIButton) {
        let contact = CNMutableContact()
        contact.givenName = txtGiveName.text!
        contact.familyName = txtFamilyName.text!
        for index in 0...listLabel.count - 1 {
            contact.phoneNumbers.insert(CNLabeledValue(label: listLabel[index].text!, value: CNPhoneNumber(stringValue: listTextFieldPhone[index].text!)), at: index)
        }

        if DataProvider.sharedInstance.updateContact(identifierContact: self.contactInfor.identifier, oldValue: contactInfor, newValue: contact) {
            btnSave.isEnabled = false
            print("Success!")
            handleDone(sender: sender)
        } else {
            print("Fail!")
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
