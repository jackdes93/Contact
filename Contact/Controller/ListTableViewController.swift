//
//  ListTableViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 5/29/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var arrayItems = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTempleDataUser(users: 5)
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
//    Data Example User
    func createTempleDataUser(users number: Int) {
        for num in 0...number  {
            let user = User(userName: "Employer \(num)", phoneNumber: "142\(num + 1)5432\(num)", nameImage: nil)
            arrayItems.append(user)
        }
    }
    
//    Alert add new contact
    func addNewUser() {
        var newUser = User()
        let alert = UIAlertController(title: "Add new user", message: "", preferredStyle: .alert)  // Defind alert view
        
//        add textField into alert view
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Phone number"
        }
        
//        add action
        let actionAdd = UIAlertAction(title: "Add", style: .default, handler: { (alertAction) in
            let nameUser = alert.textFields![0] as UITextField
            let phoneNumber = alert.textFields![1] as UITextField
            
            newUser = User(userName: nameUser.text!, phoneNumber: phoneNumber.text!, nameImage: nil)
            self.arrayItems.append(newUser)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
//    Setting Table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCellTableView
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = .yellow
        } else {
            cell.backgroundColor = .none
        }
        cell.lblName.text = arrayItems[indexPath.row].userName
        cell.lblPhone.text = arrayItems[indexPath.row].phoneNumber
        cell.imgAvatar.image = UIImage(named: "imageUser.png")
        
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

        }

        let move = UITableViewRowAction(style: .default, title: "Move") { (action, index) in

        }

        return [deletion, move]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            tableView.deleteRows(at: [1, 3], with: .fade)
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

    
    //    Event Button
    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        addNewUser()
        self.tableView.reloadData()
    }
}
