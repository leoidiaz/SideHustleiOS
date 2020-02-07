//
//  WeeklyViewController.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/8/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class WeeklyViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hoursOrDailyLabel: UILabel!
    @IBOutlet weak var hoursOrDailyValue: UILabel!
    
    var dayItems: Results<Weekly>?
    var rowSelected = 0
    let realm = try! Realm()
    

    
    var selectedMonth: Total? {
        didSet{
            loadDays()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedMonth!.totalName
        sumTotal()
        labelUpdate()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        tableView.register(UINib(nibName: "WeeklyCell", bundle: nil), forCellReuseIdentifier: "DailyCell")
        tableView.delegate = self
        tableView.dataSource = self
        sumTotal()
    }
    
    
    
    //MARK: - Add A Work Day
    
    @IBAction func addDayPressed(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
        performSegue(withIdentifier: "InputWorkDay", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditWorkDay" {
            let destinationVC = segue.destination as! EditHoursViewController
            destinationVC.weeklyInstance = self
            if let selectedItem = dayItems?[rowSelected]{
                destinationVC.selectedDay = selectedItem
                destinationVC.dailyOrHourlyCheck = selectedItem.dayIndex
            }
        } else {
            let destinationVC = segue.destination as! NewHoursViewController
            destinationVC.selectedDay = selectedMonth
            destinationVC.weeklyInstance = self
            if let firstDayIndex = selectedMonth?.days.first?.dayIndex{
                destinationVC.dailyOrHourlyCheck = firstDayIndex
            }
        }
        
    }
    
    
    
    //MARK: - Data Manipulation Methods
    func loadDays() {
    dayItems = selectedMonth?.days.sorted(byKeyPath: "dayDate", ascending: true)
    }
    
    
    func labelUpdate() {
        if let firstDayIndex = selectedMonth?.days.first?.dayIndex{
            if firstDayIndex == 0 {
                hoursOrDailyLabel.text = "Days:"
            } else {
                hoursOrDailyLabel.text = "Hours:"
            }
        }
    }
    
    func sumTotal () {
        if let currentTotal = selectedMonth?.days {
            let allHours: Double = currentTotal.sum(ofProperty: "dayOrHourly")
            let allRates: Double = currentTotal.sum(ofProperty: "dayTotal")
            hoursOrDailyValue.text = String(format: "%.2f", allHours)
            totalLabel.text = "Total: $\(String(format: "%.2f", allRates))"
        } else {
            hoursOrDailyLabel.text = "Hours:"
            hoursOrDailyValue.text = "0.00"
            totalLabel.text = "Total: $0.00"
        }
    }
    
}



//MARK: - Table View Delegates / Data source
extension WeeklyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyCell", for: indexPath) as! WeeklyCell
        cell.delegate = self
        cell.backgroundColor = UIColor(named:"darkModeBackground")
        
        if let item = dayItems?[indexPath.row] {
            cell.dateLabel.text = item.dayName
            cell.hoursLabel.text = String(format: "%.2f", item.dayOrHourly)
            cell.rateLabel.text = "$\(String(format: "%.2f", item.dayPay))"
            cell.totalLabel.text = "$\(String(format: "%.2f", item.dayTotal))"
            cell.descriptionLabel.text = item.dayDescription
            if item.dayIndex == 0 {
                cell.hoursText.isHidden = true
                cell.rateLabel.isHidden = true
                cell.rateText.isHidden = true
                cell.totalLabel.text = "$\(String(format: "%.2f", item.dayTotal))"
                cell.hoursLabel.isHidden = true
            }
            labelUpdate()
            sumTotal()
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            rowSelected = indexPath.row
            performSegue(withIdentifier: "EditWorkDay", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Delete Item
    
    func updateModel(at indexPath: IndexPath){
        if let day = dayItems?[indexPath.row]{
            do {
                try realm.write {
                    realm.delete(day)
                    sumTotal()
                    labelUpdate()
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        
        
    }
}



//MARK: - Swipe Cell Kit Delegate

extension WeeklyViewController: SwipeTableViewCellDelegate {
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
                          }),
                          from: self)
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
    
}
