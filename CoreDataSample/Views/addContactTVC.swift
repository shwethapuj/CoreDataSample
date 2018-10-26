//
//  addContactTVC.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

class addContactTVC: UITableViewCell,ReusableView,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var contactnumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var secondNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    let pickerView = UIPickerView()
    var myPickerData = [String](arrayLiteral: "Lucy")
    var submitted : (([String: Any], Bool, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.layer.frame.width / 2
        saveButton.layer.cornerRadius = 5.0
        contactnumberTextField.keyboardType = .numberPad
        emailTextField.delegate = self
        pickerView.delegate = self
        countryTextField.inputView = pickerView
        nameTextField.setBottomBorder()
        secondNameTextField.setBottomBorder()
        contactnumberTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        countryTextField.setBottomBorder()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^[6-9]\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    @objc func submitButtonClicked(){
        var userinfo : [ String: Any] = ["firstname":"",
                                            "lastName":"",
                                            "email":"",
                                            "country":"",
                                            "contact":""]
        if(nameTextField.text == "" || secondNameTextField.text == "" || emailTextField.text == "" || contactnumberTextField.text == "" || countryTextField.text == ""){
            if let click = self.submitted{
                click(userinfo,false,"All fields are mandatory")
            }
        }
        else if(!isValidEmail(testStr: emailTextField.text!)){
            if let click = self.submitted{
                click(userinfo,false,"Enter Valid Email")
            }
        }
        else if (!validate(value: contactnumberTextField.text!)){
            if let click = self.submitted{
                click(userinfo,false,"Enter Valid Contact number")
            }
        }
        else{
            userinfo["firstname"] = nameTextField.text
            userinfo["lastName"] = secondNameTextField.text
            userinfo["email"] = emailTextField.text
            userinfo["contact"] = contactnumberTextField.text
            userinfo["country"] = countryTextField.text
            if let click = self.submitted{
                click(userinfo,true,"")
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myPickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = myPickerData[row]
    }
    
}


















