//
//  ViewController.swift
//  CoreDataTask
//
//  Created by ios1 on 24/10/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBAction func AddnewButtonClicked(_ sender: Any) {
        
        addContactButtonClicked()
    }
    @IBOutlet weak var addNewContact: UIBarButtonItem!
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    @IBOutlet weak var searchBar: UISearchBar!
    var people: [NSManagedObject] = []
    var filteredPeople: [NSManagedObject] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchBar.delegate = self
        tableView.register(UINib(nibName: NoDataTVC.nibName, bundle: nil), forCellReuseIdentifier: NoDataTVC.reuseIdentifier)
        tableView.register(UINib(nibName: DisplayContactTVC.nibName, bundle: nil), forCellReuseIdentifier: DisplayContactTVC.reuseIdentifier)
        self.filteredPeople = people
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorInset = UIEdgeInsets.zero
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
      }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Person")
    
        do {
            people = try managedContext.fetch(fetchRequest)
            self.filteredPeople = people
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filteredPeople.count == 0){
            return 1
        }
        else{
        return filteredPeople.count
        }
    }
   @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(filteredPeople.count == 0){
           let cell = tableView.dequeueReusableCell(withIdentifier: NoDataTVC.reuseIdentifier, for: indexPath) as! NoDataTVC
           return cell
        }
        else{
    
        let person = filteredPeople[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DisplayContactTVC.reuseIdentifier, for: indexPath) as! DisplayContactTVC
        cell.nameLabel.text = person.value(forKeyPath: "firstname") as? String
        cell.contactNumberLabel.text = person.value(forKeyPath: "contact") as? String
        cell.selectionStyle = .none
        if let str = person.value(forKeyPath: "filePath") as? String{
        let url = URL(string: str)
        if FileManager.default.fileExists(atPath: url!.path) {
            let url = NSURL(string: (person.value(forKeyPath: "filePath") as! String))
            let data = NSData(contentsOf:  url! as URL)
            cell.imageViewOutlet.image = UIImage(data: data! as Data)
            cell.imageViewOutlet.layer.cornerRadius = cell.imageViewOutlet.layer.frame.width / 2
            cell.imageViewOutlet.clipsToBounds = true
        }
        }
        return cell
        }
    }
    
    func addContactButtonClicked(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AddContactVC") as? AddContactVC
        self.navigationController?.pushViewController(viewController!, animated: false)
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
       }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
        let predicate1 = NSPredicate(format: "firstname contains[c] '\(searchText)'")
        let predicate2 = NSPredicate(format: "contact contains[c] '\(searchText)'")
        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: [predicate1,predicate2])
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Person")
            fetchRequest.predicate = predicateCompound
            do {
                filteredPeople = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
                }
            }
        else{
      filteredPeople = self.people
        }
        tableView.reloadData()
    }
    
}

