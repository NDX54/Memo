//
//  ItemsViewController.swift
//  Memo
//
//  Created by Jared Juangco on 29/9/21.
//

import UIKit
import RealmSwift

class NoteItemsViewController: UITableViewController {
    
    private var items = [NoteItem]()
    private var selectedFolder : Folder? {
        didSet {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCellIdentifier, for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()

        
        contentConfig.text = items[indexPath.row].title
        cell.contentConfiguration = contentConfig
        cell.backgroundConfiguration = backgroundConfig

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: K.Segues.goToTextEdit, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == K.Segues.goToTextEdit {
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
                guard let text = textField.text else { fatalError("Error while acquiring text from text field.") }
                
                let newItem = NoteItem()
                newItem.title = text
                
                items.append(newItem)
                
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
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
