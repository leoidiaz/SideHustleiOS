//
//  TotalTableViewController.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 12/27/19.
//  Copyright © 2019 Leonardo Diaz. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class TotalTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var months: Results<Total>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var editButtonLabel: UIBarButtonItem!
    
    var editActive = false

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        editActive = !editActive
        if editActive {
            editButtonLabel.title = "Done"
            tableView.backgroundColor = .init(white: 0.5, alpha: 0.4)
            searchBar.isHidden = true
        } else {
            editButtonLabel.title = "Edit"
            tableView.backgroundColor = UIColor(named: "darkModeBackground")
            searchBar.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadMonths()
    }
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = months?[indexPath.row].totalName ?? "No Months added yet"
        cell.backgroundColor = UIColor(named: "darkModeBackground")

        return cell
    }
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editActive {
            var textField = UITextField()
            let alert = UIAlertController(title: "Edit a collection", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Update", style: .default) { (action) in
                if textField.text != "" {
                    do {
                        try self.realm.write {
                            self.months![indexPath.row].totalName = textField.text!
                            self.loadMonths()
                        }
                    } catch {
                        print("Error deleting month, \(error)")
                    }
                } else {
                    textField.placeholder = "Please enter a Collection Name"
                }
            }

            let dismiss = UIAlertAction(title: "Cancel", style: .default) { (dismiss) in
                alert.dismiss(animated: true, completion: nil)
            }

            alert.addTextField { (alertTextField) in
                alertTextField.text = self.months![indexPath.row].totalName
                textField = alertTextField
            }

            alert.addAction(dismiss)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            performSegue(withIdentifier: "SelectedMonth", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! WeeklyViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedMonth = months?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(month: Total) {
        do{
            try realm.write{
                realm.add(month)
            }
        } catch {
            print("Error saving month \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadMonths() {
        months = realm.objects(Total.self)
//            .sorted(byKeyPath: "totalName", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteMonth = self.months?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(deleteMonth)
                }
            } catch {
                print("Error deleting month, \(error)")
            }
        }
    }
    
    
    //MARK: - Add New Months
    
    @IBAction func newMonthPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add A New Collection", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //Create a REALM Object
            let newMonth = Total()
            
            if textField.text != "" {
                newMonth.totalName = textField.text!
                self.save(month: newMonth)
            } else {
                textField.placeholder = "Please enter a Collection Name"
            }
            
        }
        
        let dismiss = UIAlertAction(title: "Cancel", style: .default) { (dismiss) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Collection"
            textField = alertTextField
        }
        
        alert.addAction(dismiss)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
}


//MARK: - Search Bar Delegate

extension TotalTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
           months = months?.filter("totalName CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "totalName", ascending: true)
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadMonths()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        
    }
    
    
    

    
}
