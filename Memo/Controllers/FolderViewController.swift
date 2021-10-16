//
//  FolderViewController.swift
//  Memo
//
//  Created by Jared Juangco on 14/10/21.
//

import UIKit
import RealmSwift

class FolderViewController: UITableViewController {
    
    var folders : Results<Folder>?
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Folders"
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }
        navBar.prefersLargeTitles = true
        
        loadFolders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }
        navBar.prefersLargeTitles = true
        navBar.backgroundColor = .systemMint
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    // MARK: - Data Manipulation Methods
    
    private func save(withNewFolderName folderName: String) {
        do {
            try realm.write {
                let newFolder = Folder()
                newFolder.title = folderName
                newFolder.uid = UUID()
                newFolder.dateCreated = Date()
                realm.add(newFolder)
            }
        } catch {
            print("Error saving data: \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func loadFolders() {
        
        folders = realm.objects(Folder.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCellIdentifier", for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        
        if let folders = folders?[indexPath.row] {
            contentConfig.text = folders.title
            cell.contentConfiguration = contentConfig
            cell.backgroundConfiguration = backgroundConfig
            return cell
        } else {
            contentConfig.text = "No folders added yet."
            cell.contentConfiguration = contentConfig
            cell.backgroundConfiguration = backgroundConfig
            return cell
        }
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segues.goInsideSelectedFolder, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .normal, title: "Trash") { (uiContAct, view, success) in
            success(true)
        }
        trashAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (uiContAct, view, success) in
            
            success(true)
        }
        
        editAction.backgroundColor = .blue
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [trashAction, editAction])
        
        return swipeConfig
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == K.Segues.goInsideSelectedFolder {
            let destVC = segue.destination as! NoteItemsViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destVC.selectedFolder = folders?[indexPath.row]
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
                guard let newName = textField.text else { fatalError("Error while acquiring text from text field. ") }
                
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


