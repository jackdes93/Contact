//
//  ListTableViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Foundation
import Contacts

class ListTableViewController: UITableViewController {
    //    MARK: Defind variable
    var arrayItems = [CNContact]()
    var listAlphabetically = [String]()
    var sections = [[CNContact]]()
    var sharedInstant = DataProvider.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = editButtonItem
        arrayItems = sharedInstant.fetchDataContact()
        listAlphabetically = Array(Set(self.arrayItems.map { $0.familyName.firstCharacterOfString()})).sorted()
        sections = listAlphabetically.map { list in
            return arrayItems
                .filter { $0.familyName.firstCharacterOfString() == list}
                .sorted {$0.familyName > $1.familyName }
        }
        
    }
   
    
    //  MARK:  Function
    func addNewUser() {
        let alert = UIAlertController(title: "Liên Hệ Mới", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Họ" }
        alert.addTextField { (textField) in textField.placeholder = "Tên Liên Hệ" }
        alert.addTextField { (textField) in textField.placeholder = "Số Điện Thoại" }
        
        let actionAdd = UIAlertAction(title: "Thêm", style: .default, handler: { (alertAction) in
            let familyName = alert.textFields![0] as UITextField
            let givenName = alert.textFields![1] as UITextField
            let phoneNumber = CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: (alert.textFields![2] as UITextField).text!))
            let newContact = CNMutableContact()
            
            newContact.familyName = familyName.text!
            newContact.givenName = givenName.text!
            newContact.phoneNumbers = [phoneNumber]
            self.sharedInstant.addNewContact(contact: newContact)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    //    MARK: Delegate & Protocal Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listAlphabetically.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listAlphabetically
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return listAlphabetically[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCellTableView
        if let imageData = sections[indexPath.section][indexPath.row].imageData {
            cell.imgAvatar.image = UIImage(data: imageData)
        } else {
            cell.imgAvatar.image = UIImage(named: "imageUser.png")
        }
        cell.lblName.text = "\(sections[indexPath.section][indexPath.row].familyName) \(sections[indexPath.section][indexPath.row].givenName)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deletion = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            self.arrayItems.remove(at: indexPath.row)
            tableView.reloadData()
        }

        let move = UITableViewRowAction(style: .default, title: "Move") { (action, index) in
           tableView.setEditing(true, animated: true)
        }
        
        move.backgroundColor = .gray
        
        let checkMark = UITableViewRowAction(style: .default, title: "Chek") { (action, index) in
            if let cell = tableView.cellForRow(at: index) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            }
        }
        
        checkMark.backgroundColor = .blue
        
        return [deletion, checkMark]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.arrayItems.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
   override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowMove = self.arrayItems[sourceIndexPath.row]
        arrayItems.remove(at: sourceIndexPath.row)
        arrayItems.insert(rowMove, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

//    Action with cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var indexPath = self.tableView.indexPathForSelectedRow!
        if let destination = segue.destination as? ViewController {
            destination.contact = sections[indexPath.section][indexPath.row]
        }
    }
//  MARK:  Event Button
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        addNewUser()
        self.tableView.reloadData()
    }
}

// MARK: Extension
public extension String {

    func firstCharacterOfString() -> String {
        return String(self[self.startIndex]).uppercased()
    }
    
    mutating func replaceString(string:String, at startIndex:String.Index, ofSetBy: Int) -> String {
        let range = startIndex..<self.index(startIndex, offsetBy: ofSetBy)
        self.replaceSubrange(range, with: string)

        return self
    }
}
