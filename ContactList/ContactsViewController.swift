//
//  ContactsViewController.swift
//  ContactList
//
//  Created by Eldor Makkambaev on 30.04.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController {

    @IBOutlet weak var noContactLabel: UILabel!
    var contacts: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        tableView.reloadData()
        if contacts.count > 0 {
            noContactLabel.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactTableViewCell
        
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.value(forKey: "name") as? String
        cell.phoneLabel.text = contact.value(forKey: "phoneNumber") as? String
        if contact.value(forKey: "gender") as? String == "Male"{
            cell.imageContact.image = UIImage(named: "male.png")
        }
        else if contact.value(forKey: "gender") as? String == "Female"{
            cell.imageContact.image = UIImage(named: "female.png")
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            guard let viewController = segue.destination as? ContactDetailViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = contacts[(indexPath.row)]
            
            viewController.contact = contact
            viewController.indexPath = indexPath
        }
    }
    
    
    @IBAction func unwindToContactList(segue: UIStoryboardSegue){
        if let viewController = segue.source as? AddContactViewController{
            
            guard let addContactView = segue.source as? AddContactViewController else {return }
            guard let name = addContactView.nameTextField.text, let phone = addContactView.phoneTextField.text,
                let gender = addContactView.gender else {return }
            guard name != "", phone != "" else { return }
            print("blablabla")
            
            if let indexPath = viewController.indexPathForContact{
                update(indexPath: indexPath, name: name, phoneNumber: phone, gender: gender)
            } else{
                save(name: name, phoneNumber: phone, gender: gender)
            }
            tableView.reloadData()
        }
        else if let viewController = segue.source as? ContactDetailViewController {
            if viewController.isDeleted {
                guard let indexPath = viewController.indexPath else { return }
                let contact = contacts[indexPath.row]
                delete(contact: contact, at: indexPath)
                contacts.remove(at: indexPath.row)
                tableView.reloadData()
                
            }
        }
        
        if contacts.count == 0{
            noContactLabel.isHidden = false
        }
        else if contacts.count > 0 {
            noContactLabel.isHidden = true
        }
        tableView.reloadData()
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delete(contact: contacts[indexPath.row], at: indexPath)
        contacts.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    func fetch(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    
    func save(name: String, phoneNumber: String, gender: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Contact", in: managedObjectContext) else { return }
        let contact = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        contact.setValue(gender, forKey: "gender")
        do {
            try managedObjectContext.save()
            contacts.append(contact)
            
        } catch let error as NSError {
            print("\(error)")
            print("Culdn't save")
        }
    }
    func update(indexPath: IndexPath, name: String, phoneNumber: String, gender: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let contact = contacts[indexPath.row]
        contact.setValue(name, forKey: "name")
        contact.setValue(phoneNumber, forKey: "phoneNumber")
        contact.setValue(gender, forKey: "gender")
        do {
            try managedObjectContext.save()
            contacts[indexPath.row] = contact
        } catch let error as NSError {
            print("\(error)")
            print("Culdn't save")
        }
    }
    func delete(contact: NSManagedObject, at indexPath: IndexPath){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        managedObjectContext.delete(contact)
        //contacts.remove(at: indexPath.row)
    }
}
