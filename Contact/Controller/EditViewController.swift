//
//  EditViewController.swift
//  Contact
//
//  Created by Đái Phương Bình on 6/14/18.
//  Copyright © 2018 Đái Phương Bình. All rights reserved.
//

import UIKit
import Foundation

class EditViewController: UIViewController {
    
    var testString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
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

}
