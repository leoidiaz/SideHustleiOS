//
//  ViewController.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 12/27/19.
//  Copyright © 2019 Leonardo Diaz. All rights reserved.
//

import UIKit
import RealmSwift

class NewHoursViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var hoursEntered: UITextField!
    @IBOutlet weak var rateEntered: UITextField!
    @IBOutlet weak var workDayPicker: UIDatePicker!
    @IBOutlet weak var descriptionEntered: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var hourlyDailyLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    var dailyOrHourlyCheck: Int?
    
    let realm = try! Realm()
    
    var selectedDay : Total?
    
    var weeklyInstance : WeeklyViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Rounded Button
        var design = ObjectDesign(button: addButton, segment: segmentControl, rate: rateEntered, description: descriptionEntered, hours: hoursEntered)
        design.applyDesign()
        // Delegate Set
        hoursEntered.delegate = self
        rateEntered.delegate = self
        descriptionEntered.delegate = self
        // Prevent copy and paste into textField
        hoursEntered.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        rateEntered.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        descriptionEntered.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        //Segemented Controls
        hourlyOrDaily()
    }
    

    
    //MARK: - Segment Control
    
    func hourlyOrDaily () {
        if dailyOrHourlyCheck == nil {
            hoursEntered.isHidden = true
            hoursEntered.text = "1"
            segmentControl.selectedSegmentIndex = 0
        } else {
            if dailyOrHourlyCheck == 1 || dailyOrHourlyCheck == -1{
                hourlyDailyLabel.text = "Hours"
                hoursEntered.isHidden = false
                segmentControl.setEnabled(false, forSegmentAt: 0)
                segmentControl.selectedSegmentIndex = dailyOrHourlyCheck!
            } else {
                hoursEntered.isHidden = true
                hoursEntered.text = "1"
                segmentControl.setEnabled(false, forSegmentAt: 1)
                segmentControl.selectedSegmentIndex = dailyOrHourlyCheck!
            }
        }
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            hourlyDailyLabel.text = "Day"
            rateEntered.placeholder = "Bread per day"
            hoursEntered.text = "1"
            hoursEntered.isHidden = true
        case 1:
            hourlyDailyLabel.text = "Hours"
            rateEntered.placeholder = "Bread per hour"
            hoursEntered.placeholder = "Hours Worked"
            hoursEntered.text = ""
            hoursEntered.isHidden = false
        default:
            break
        }
    }
    
    
    //MARK: - TextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Character Checking TextField
        if textField == hoursEntered || textField == rateEntered{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        } else {
            guard let textFieldCharacters = descriptionEntered.text else {
                    return false
            }
            let count = textFieldCharacters.count + string.count
            return count <= 25
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Done button closes keyboard
        if textField == descriptionEntered{
            textField.resignFirstResponder()
            rateEntered.becomeFirstResponder()
        } else if textField == rateEntered {
            textField.resignFirstResponder()
            if segmentControl.selectedSegmentIndex != 1{
                textField.resignFirstResponder()
            } else {
                hoursEntered.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    //MARK: - Add Data
    
    @IBAction func addPressed(_ sender: UIButton) {
        if hoursEntered.text != "" && rateEntered.text != ""{
            appendData()
            reloadView()
        } else {
            hoursEntered.placeholder = "Enter a Value"
            rateEntered.placeholder = "Enter a Rate"
        }
    }
    
    
    //MARK: - Reload TableView and Dismiss Modal
    
    func reloadView() {
        weeklyInstance.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func appendData(){
        if let currentDay = self.selectedDay {
            do {
                try realm.write {
                    //Create Date Picker Formatter
                    let newDay = Weekly()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    let stringDate = dateFormatter.string(from: workDayPicker.date)
                    
                    // Write into Realm
                    newDay.dayDate = workDayPicker.date
                    newDay.dayName = stringDate
                    newDay.dayIndex = segmentControl.selectedSegmentIndex
                    
                    if let hoursAsDouble = Double(hoursEntered.text!), let rateAsDouble = Double(rateEntered.text!){
                        newDay.dayOrHourly = hoursAsDouble
                        newDay.dayPay = rateAsDouble
                        
                        var dayTotal:Double{
                            return hoursAsDouble * rateAsDouble
                        }
                        
                        newDay.dayTotal = dayTotal
                        newDay.dayDescription = descriptionEntered.text ?? ""
                    }
                    currentDay.days.append(newDay)
                }
                
            } catch {
                print("Error saving new days, \(error)")
            }
            
        }
    }
    
    
   

    
    
}


