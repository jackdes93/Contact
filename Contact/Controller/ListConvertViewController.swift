//
//  ListConvertViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/11/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Contacts

class ListConvertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nameNetwork = DataProvider.sharedInstance.numberNetWork()
    var listNumberConvert = [[String]]()
    var listResultChange = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNumberConvert = DataProvider.sharedInstance.groupByHeaderNumber()
        for index in 0...listNumberConvert.count - 1 {
            let result = DataProvider.sharedInstance.listPhoneConvertHeaderPhoneNumber(listPhone: listNumberConvert[index]) as [String]
           listResultChange.append(result)
        }
    }
    
    // MARK: - TableView Delegate & DataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameNetwork.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  listNumberConvert[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let numberConvert = DataProvider.sharedInstance.numberOfPhoneNumberConvertHeader(listPhone: listResultChange[section])
        return "\(nameNetwork[section]) (\(numberConvert) / \(listNumberConvert[section].count))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = DataProvider.sharedInstance.convertToNewHeaderNumber(numberPhone: listNumberConvert[indexPath.section][indexPath.row])//(listResultChange[indexPath.section][indexPath.row]).isEmpty ? "Not Change" : (listResultChange[indexPath.section][indexPath.row])
        
        cell.textLabel?.text = "\(listNumberConvert[indexPath.section][indexPath.row]) => \(result)"
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Action
    @IBAction func covertToNewHeaderNumber(sender: UIButton) {
        DataProvider.sharedInstance.updateAllContactToNewHeaderNumber()
//        if result {
//            alertView(title: "Congratulation!", message: "Update new header number phone success", stateAlert: true)
//        } else {
//            alertView(title: "Fail!", message: "Some Thing error duration update", stateAlert: false)
//        }
    }
    
    // MARK: AlertView
    func alertView(title: String, message: String, stateAlert: Bool) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.tableView.reloadData()
        }
        let dimissAction = UIAlertAction(title: "Retry", style: .cancel) { (alert) in
            print("Error!")
        }
        
        if stateAlert {
            alertView.addAction(okAction)
        } else {
            alertView.addAction(dimissAction)
        }
        
        self.present(alertView, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

