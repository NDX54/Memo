//
//  ItemsViewController.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import UIKit
import RealmSwift

class NoteItemsViewController: SwipeTableViewController {
    
    private let realm = try! Realm()
    var noteItems : Results<NoteItem>?
    var selectedFolder : Folder? {
        didSet {
            loadNotes()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let folderName = selectedFolder?.title else {
            fatalError("Unable to find selected folder")
        }
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation bar does not exist")
        }

        title = folderName        
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(withNoteName noteName: String) {
        
        if let currentFolder = selectedFolder {
            do {
                try realm.write {
                    let newNoteItem = NoteItem()
                    newNoteItem.title = noteName
                    newNoteItem.id = UUID()
                    newNoteItem.dateCreated = Date()
                    currentFolder.noteItems.append(newNoteItem)
                }
            } catch {
                print("Error saving note: \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    func loadNotes() {
        noteItems = selectedFolder?.noteItems.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return noteItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        
        if let noteItems = noteItems?[indexPath.row] {
            contentConfig.text = noteItems.title
            cell.contentConfiguration = contentConfig
            cell.backgroundConfiguration = backgroundConfig

            return cell
        } else {
            contentConfig.text = "No notes added yet"
            cell.contentConfiguration = contentConfig
            cell.backgroundConfiguration = backgroundConfig

            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segues.goToTextEditView, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == K.Segues.goToTextEditView {
            let destVC = segue.destination as! TextViewController
            if let indexPath = tableView.indexPathForSelectedRow, let uniqueID = noteItems?[indexPath.row].id {
                destVC.selectedNotes = noteItems?[indexPath.row]
                destVC.uniqueID = uniqueID
            }
        }
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//        var indexPath = IndexPath()
        var textField = UITextField()
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
//        var contentConfig = cell.defaultContentConfiguration()
//        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
                
        let addAlert = UIAlertController(title: "Add New Note", message: "Enter the title of the note", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addNoteAction = UIAlertAction(title: "Add Note", style: .default) { [self] action in
            if textField.text == "" {
                DispatchQueue.main.async {
                    
                    let noTxtAlert = UIAlertController(title: "Error", message: "Please provide a name for the note", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { okAct in
                        present(addAlert, animated: true, completion: nil)
                    }
                    
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    noTxtAlert.addAction(ok)
                    noTxtAlert.addAction(cancel)
                    present(noTxtAlert, animated: true, completion: nil)
                    
                }
            } else {
                guard let noteTitle = textField.text else { fatalError("Error while acquiring text from text field.") }
                
                save(withNoteName: noteTitle)
                
            }
        }
        
        addAlert.addTextField { addAlertTxtField in
            addAlertTxtField.placeholder = "Enter a title..."
            textField = addAlertTxtField
        }
//        cell.contentConfiguration = contentConfig
//        cell.backgroundConfiguration = backgroundConfig
                
        addAlert.addAction(addNoteAction)
        addAlert.addAction(cancel)
        present(addAlert, animated: true, completion: nil)
    }
    
}
