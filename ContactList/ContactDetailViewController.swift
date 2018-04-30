//
//  ContactDetailViewController.swift
//  ContactList
//
//  Created by Eldor Makkambaev on 30.04.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import UIKit
import CoreData

class ContactDetailViewController: UIViewController {
    var contact : NSManagedObject? = nil
    var isDeleted: Bool = false
    var indexPath: IndexPath? = nil
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBAction func deleteContact(_ sender: UIButton) {
        isDeleted = true
        performSegue(withIdentifier: "unwindSegueToContactList", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = contact?.value(forKey: "name") as? String
        phoneLabel.text = contact?.value(forKey: "phoneNumber") as? String
        genderLabel.text = contact?.value(forKey: "gender") as? String
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContactSegue" {
            guard let viewController = segue.destination as? AddContactViewController else { return }
            viewController.titleText = "Edit Contact"
            viewController.contact = contact
            viewController.indexPathForContact = indexPath!
        }
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
