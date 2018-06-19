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

class DetailViewController: UIViewController, EditDelegate {
//    Defined Variable
    var contact: CNContact!
    var delegate: ViewControllerDelegate!
    var imageContact = UIImageView()
    var lblNameContact = UILabel()
    var lblTitlePhone = UILabel()
    var stackViewNumberPhone = UIStackView()
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .cyan
        return scroll
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    override func viewDidLayoutSubviews() {
//        self.view.addSubview(scrollView)
//
//        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    
        // Image autolayout
        imageContact.translatesAutoresizingMaskIntoConstraints = false
        imageContact.frame.size = CGSize(width: 120, height: 120)
        imageContact.layer.cornerRadius = imageContact.frame.width / 2
        imageContact.clipsToBounds = true
        imageContact.image = (contact.thumbnailImageData != nil) ? UIImage(data: contact.thumbnailImageData!) : #imageLiteral(resourceName: "imageUser.png")
        imageContact.contentMode = .scaleToFill
        self.view.addSubview(imageContact)
        imageContact.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageContact.heightAnchor.constraint(equalTo: imageContact.widthAnchor, multiplier: 1).isActive = true
        imageContact.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11, *) {
            imageContact.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            imageContact.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        }

        // Label name contact autolayout
        lblNameContact.translatesAutoresizingMaskIntoConstraints = false
        lblNameContact.text = "\(contact.familyName) \(contact.givenName)"
        lblNameContact.textAlignment = .center
        lblNameContact.font = UIFont.boldSystemFont(ofSize: 28)
        lblNameContact.textColor = .black
        self.view.addSubview(lblNameContact)
        lblNameContact.centerXAnchor.constraint(equalTo: imageContact.centerXAnchor).isActive = true
        lblNameContact.topAnchor.constraint(equalTo: imageContact.topAnchor, constant: imageContact.frame.height + 15).isActive = true

        // Label title Phone autolayout
        lblTitlePhone.translatesAutoresizingMaskIntoConstraints = false
        lblTitlePhone.text = "Phone :"
        lblTitlePhone.font = UIFont.boldSystemFont(ofSize: 18)
        lblTitlePhone.textColor = .black
        self.view.addSubview(lblTitlePhone)
        lblTitlePhone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        lblTitlePhone.topAnchor.constraint(equalTo: lblNameContact.topAnchor, constant: lblNameContact.frame.height + 35).isActive = true
        lblTitlePhone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true

        // StackView list phone number autolayout
        stackViewNumberPhone.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackViewNumberPhone)
        stackViewNumberPhone.topAnchor.constraint(equalTo: lblTitlePhone.topAnchor, constant: lblTitlePhone.frame.height + 20).isActive = true
        stackViewNumberPhone.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        stackViewNumberPhone.leadingAnchor.constraint(equalTo: lblTitlePhone.leadingAnchor, constant: 10).isActive = true
        stackViewNumberPhone.trailingAnchor.constraint(equalTo: lblTitlePhone.trailingAnchor, constant: 0).isActive = true
        stackViewNumberPhone.axis = .vertical
        stackViewNumberPhone.alignment = .fill
        stackViewNumberPhone.distribution = .fillEqually
        stackViewNumberPhone.spacing = 10
        stackViewNumberPhone.changeBackgroundColor(color: .red)
        addListPhoneNumber(contact: contact)
    }
    
    // MARK: Autolayout
    private func addListPhoneNumber(contact: CNContact) {
        let range = contact.phoneNumbers.count - 1
        for index in 0...range {
            let subStackView = UIStackView()
            subStackView.translatesAutoresizingMaskIntoConstraints = false
            stackViewNumberPhone.addArrangedSubview(subStackView)
            subStackView.axis = .horizontal
            subStackView.alignment = .fill
            subStackView.distribution = .fillEqually
            subStackView.spacing = 10
            
            let lblLabelValue = UILabel()
            lblLabelValue.translatesAutoresizingMaskIntoConstraints = false
            subStackView.addArrangedSubview(lblLabelValue)
            lblLabelValue.text = contact.phoneNumbers[index].label
            lblLabelValue.textColor = .black
            
            let txtPhoneNumber = UITextField()
            txtPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
            subStackView.addArrangedSubview(txtPhoneNumber)
            txtPhoneNumber.textColor = .blue
            txtPhoneNumber.text = contact.phoneNumbers[index].value.stringValue
        }
        
    }
    
    // MARK: Navigation
    override var prefersStatusBarHidden: Bool {
        return true;
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        if let editView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditView") as? EditViewController {
            editView.contactInfor = contact
                present(editView, animated: true, completion: nil)
        }
    
    }
    
    //    MARK: Reload from Delegate
    func reloadDataUpdate(newcontact: CNContact) {

    }
}


