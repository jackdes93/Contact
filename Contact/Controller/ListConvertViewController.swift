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
    var nameNetwork = ["MOBIFONE", "VINAPHONE", "VIETTEL", "VIETNAMMOBILE", "GMOBILE", "OTHER"]
    var listNumberConvert = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listNumberConvert = DataProvider.sharedInstance.groupByHeaderNumber()
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
        return "\(nameNetwork[section])  (\(listNumberConvert[section].count))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listNumberConvert[indexPath.section][indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
