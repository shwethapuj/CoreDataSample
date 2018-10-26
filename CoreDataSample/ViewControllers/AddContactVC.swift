//
//  AddContactVC.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit
import CoreData

class AddContactVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
   
    var countryList = [String]()
    var imageFilePath : String?
    var image : UIImage?
    let picker = UIImagePickerController()
    var people: [NSManagedObject] = []
    var model : CountryListModelClass?
    lazy var userinfo : [ String: Any] = ["firstname":"",
                                        "lastName":"",
                                        "email":"",
                                        "country":"",
                                        "contact":""]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: addContactTVC.nibName, bundle: nil), forCellReuseIdentifier: addContactTVC.reuseIdentifier)
        self.model = CountryListModelClass()
        self.model?.parseJSON(completion: { (data) in
            self.countryList.removeAll()
            for anitem in data{
                self.countryList.append(anitem.name)
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addContactTVC.reuseIdentifier, for: indexPath) as! addContactTVC
        cell.selectionStyle = .none
        cell.myPickerData = self.countryList.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        
        self.userinfo["firstname"] = cell.nameTextField.text
        self.userinfo["lastName"] = cell.secondNameTextField.text
        self.userinfo["email"] = cell.emailTextField.text
        self.userinfo["country"] = cell.countryTextField.text
        self.userinfo["contact"] = cell.contactnumberTextField.text
        cell.addPhotoLabel.isHidden = false
        let taprec = UITapGestureRecognizer(target: self, action: #selector(photoFromLibrary))
        cell.imageViewOutlet?.isUserInteractionEnabled = true
        if let image = self.image{
            cell.imageViewOutlet.image = image
            cell.imageViewOutlet.layer.cornerRadius = cell.imageViewOutlet.layer.frame.width / 2
            cell.imageViewOutlet.clipsToBounds = true
            cell.addPhotoLabel.isHidden = true
        }
        cell.imageViewOutlet?.addGestureRecognizer(taprec)
        cell.submitted = {(data, flag, message) in
            self.view.endEditing(true)
            if self.image != nil{
                if(flag){
                    self.userinfo = data
                    self.userinfo["filePath"] = self.imageFilePath
                    self.save()
                    self.navigationController?.popViewController(animated: false)
                }
                else{
                    self.showToast(message: message)
                }
             
            }
            else{
                self.showToast(message: "Please select image")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return UITableViewAutomaticDimension
    }
    
    @objc func addContactButtonClicked(){
       // self.save()
    }

    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue( self.userinfo["firstname"], forKeyPath: "firstname")
        person.setValue( self.userinfo["lastName"], forKeyPath: "lastName")
        person.setValue( self.userinfo["email"], forKeyPath: "email")
        person.setValue( self.userinfo["country"], forKeyPath: "country")
        person.setValue( self.userinfo["contact"], forKeyPath: "contact")
        person.setValue( self.userinfo["filePath"], forKeyPath: "filePath")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    @objc func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if #available(iOS 11.0, *) {
            if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
                let imgName = imgUrl.lastPathComponent
                var documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                documentDirectory = documentDirectory?.appending("/")
                let localPath = documentDirectory?.appending(imgName)
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                self.image = image
                let data = UIImagePNGRepresentation(image)! as NSData
                data.write(toFile: localPath!, atomically: true)
                let photoURL = URL.init(fileURLWithPath: localPath!)
                self.imageFilePath = "\(photoURL)"
            }
        } else {
            // Fallback on earlier versions
        }
        dismiss(animated:true, completion: nil)
        self.tableView.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: 10, y: self.view.frame.size.height/2 - 20, width: self.view.frame.size.width - 20, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
 }

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
