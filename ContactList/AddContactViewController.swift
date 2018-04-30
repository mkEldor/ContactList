//
//  AddContactViewController.swift
//  ContactList
//
//  Created by Eldor Makkambaev on 30.04.2018.
//  Copyright © 2018 Eldor Makkambaev. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController,  UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    var genders: [String] = ["Male", "Female"]
    
    var gender: String? = "Male"
    var titleText = "Add Contact"
    var contact: NSManagedObject? = nil
    var indexPathForContact: IndexPath? = nil
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBAction func saveAndClose(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToContactList", sender: self)

    }
    @IBAction func close(_ sender: UIButton) {
        nameTextField.text = nil
        phoneTextField.text = nil
        gender = nil
        performSegue(withIdentifier: "unwindToContactList", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        phoneTextField.delegate = self
        titleLabel.text = titleText
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.selectRow(0, inComponent:0, animated:true)
        if let contact = contact {
            nameTextField.text = contact.value(forKey: "name") as? String
            phoneTextField.text = contact.value(forKey: "phoneNumber") as? String
            if contact.value(forKey: "gender") as? String == "Male"{
                genderPicker.selectRow(0, inComponent:0, animated:true)
            }
            else if contact.value(forKey: "gender") as? String == "Female"{
                genderPicker.selectRow(1, inComponent:0, animated:true)
            }
            
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.view.endEditing(false)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = genders[row]
        //print(gender)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
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
