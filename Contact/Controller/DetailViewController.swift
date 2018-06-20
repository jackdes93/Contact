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
    
    var imageContact: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.frame.size = CGSize(width: 120, height: 120)
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        return image
    }()
    
    var lblNameContact: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textAlignment = .center
        lbl.textColor = .black
        return lbl
    }()
    var lblTitlePhone: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.text = "Phone : "
        lbl.textColor = .black
        return lbl
    }()
    var stackViewNumberPhone = UIStackView()
    var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.contentSize.height = 900
        return scroll
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewDidLayoutSubviews() {
        self.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 80).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        // Image autolayout
        imageContact.image = (contact.thumbnailImageData != nil) ? UIImage(data: contact.thumbnailImageData!) : #imageLiteral(resourceName: "imageUser.png")
        scrollView.addSubview(imageContact)
        imageContact.heightAnchor.constraint(equalToConstant: 120).isActive = true
        imageContact.heightAnchor.constraint(equalTo: imageContact.widthAnchor, multiplier: 1).isActive = true
        imageContact.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageContact.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10).isActive = true
       

        // Label name contact autolayout
        lblNameContact.text = "\(contact.familyName) \(contact.givenName)"
        scrollView.addSubview(lblNameContact)
        lblNameContact.centerXAnchor.constraint(equalTo: imageContact.centerXAnchor).isActive = true
        lblNameContact.topAnchor.constraint(equalTo: imageContact.topAnchor, constant: imageContact.frame.height + 15).isActive = true
        
        // Label title Phone autolayout
        scrollView.addSubview(lblTitlePhone)
        lblTitlePhone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        lblTitlePhone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        lblTitlePhone.topAnchor.constraint(equalTo: lblNameContact.topAnchor, constant: lblNameContact.frame.height + 35).isActive = true

        // StackView list phone number autolayout
        stackViewNumberPhone.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackViewNumberPhone)
        stackViewNumberPhone.topAnchor.constraint(equalTo: lblTitlePhone.topAnchor, constant: lblTitlePhone.frame.height + 20).isActive = true
        stackViewNumberPhone.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        stackViewNumberPhone.leadingAnchor.constraint(equalTo: lblTitlePhone.leadingAnchor, constant: 10).isActive = true
        stackViewNumberPhone.trailingAnchor.constraint(equalTo: lblTitlePhone.trailingAnchor, constant: -10).isActive = true
        stackViewNumberPhone.axis = .vertical
        stackViewNumberPhone.alignment = .fill
        stackViewNumberPhone.distribution = .fillProportionally
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
            subStackView.distribution = .equalSpacing
            subStackView.spacing = 5
            
            let lblLabelValue = UILabel()
            lblLabelValue.translatesAutoresizingMaskIntoConstraints = false
            subStackView.addArrangedSubview(lblLabelValue)
            lblLabelValue.text = contact.phoneNumbers[index].label
            lblLabelValue.textColor = .black
            
            let txtPhoneNumber = UITextField()
            txtPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
            subStackView.addArrangedSubview(txtPhoneNumber)
            txtPhoneNumber.textColor = .blue
            txtPhoneNumber.isUserInteractionEnabled = false
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
        for item in newcontact.phoneNumbers {
            print(item.value.stringValue)
        }
    }
}


