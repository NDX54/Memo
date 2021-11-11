//
//  SwipeTableViewController.swift
//  Memo
//
//  Created by Jared Juangco on 16/10/21.
//

import UIKit

class SwipeTableViewController: UITableViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (uiContAct, view, success) in
            self.deleteModel(at: indexPath)
            success(true)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (uiContAct, view, success) in
            
            self.editModel(at: indexPath)
            success(true)
        }
        
        editAction.backgroundColor = .blue
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeConfig
    }
    
    func deleteModel(at indexPath: IndexPath) {
        print("\(#function) called from superclass.")
    }
    
    func editModel(at indexPath: IndexPath) {
        print("\(#function) called from superclass")
    }
    
    

}
