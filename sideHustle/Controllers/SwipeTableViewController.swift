//
//  SwipeTableViewController.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/7/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 65.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle action by updating model with deletion
            
            Alert.present(title: "",
                          message: "Are you sure you want to do that?",
                          actions: Alert.Action.dismiss(handler: {
                            self.dismiss(animated: true, completion: nil)
                            action.fulfill(with: .reset)
                          }),
                          Alert.Action.delete(handler: {
                            self.updateModel(at: indexPath)
                            action.fulfill(with: .delete)
                          }), from: self)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-image")
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }
    
    //MARK: - Update fuction Passed into the delete action

    func updateModel(at indexPath: IndexPath){
        //Update model at current state
    }

}
