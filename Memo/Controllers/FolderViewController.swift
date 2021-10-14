//
//  FolderViewController.swift
//  Memo
//
//  Created by Jared Juangco on 14/10/21.
//

import UIKit
import RealmSwift

class FolderViewController: UITableViewController {
    
    private var foldersList = [Folder]()
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let folder1 = Folder()
//        folder1.title = "Financial"
//        foldersList.append(folder1)
//        
//        let folder2 = Folder()
//        folder2.title = "Home"
//        foldersList.append(folder2)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(withNewFolderName folderName: String) {
        do {
            try realm.write {
                let newFolder = Folder()
                newFolder.title = folderName
                realm.add(newFolder)
            }
        } catch {
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foldersList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCellIdentifier", for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        
        
        contentConfig.text = foldersList[indexPath.row].title
        cell.contentConfiguration = contentConfig
        cell.backgroundConfiguration = backgroundConfig
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segues.goInsideSelectedFolder, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == K.Segues.goInsideSelectedFolder {
            let destVC = segue.destination as! TextViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                
            }
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //        var indexPath = IndexPath()
        var textField = UITextField()
        //        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
        //        var contentConfig = cell.defaultContentConfiguration()
        //        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        
        let addAlert = UIAlertController(title: "Add New Folder", message: "Enter the name of the folder", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addFolderAction = UIAlertAction(title: "Add New Folder", style: .default) { [self] action in
            if textField.text == "" {
                DispatchQueue.main.async {
                    
                    let noTxtAlert = UIAlertController(title: "Error", message: "Please provide a name for the folder", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { okAct in
                        present(addAlert, animated: true, completion: nil)
                    }
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    noTxtAlert.addAction(ok)
                    noTxtAlert.addAction(cancel)
                    present(noTxtAlert, animated: true, completion: nil)
                    
                }
            } else {
                guard let newName = textField.text else { fatalError("Error while acquiring text from text field.") }
                
                save(withNewFolderName: newName)
            }
        }
        
        addAlert.addTextField { addAlertTxtField in
            addAlertTxtField.placeholder = "Enter a title..."
            textField = addAlertTxtField
        }
        //        cell.contentConfiguration = contentConfig
        //        cell.backgroundConfiguration = backgroundConfig
        
        addAlert.addAction(addFolderAction)
        addAlert.addAction(cancel)
        present(addAlert, animated: true, completion: nil)
    }
}


