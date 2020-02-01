//
//  EditHoursViewController.swift
//  sideHustle
//
//  Created by Leonardo Diaz on 1/14/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit
import RealmSwift

class EditHoursViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var workDayEdited: UIDatePicker!
    @IBOutlet weak var rateEdited: UITextField!
    @IBOutlet weak var hoursEdited: UITextField!
    @IBOutlet weak var descriptionEdited: UITextField!
    @IBOutlet weak var hourDailyLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var updateButton: UIButton!
    
    let realm = try! Realm()
    
    var selectedDay: Weekly!
    
    var dailyOrHourlyCheck: Int?
    
    var weeklyInstance: WeeklyViewController!
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        //Rounded Button & textFields
        var design = ObjectDesign(button: updateButton, segment: segmentControl, rate: rateEdited, description: descriptionEdited, hours: hoursEdited)
        design.applyDesign()
        //Delegate Set
        rateEdited.delegate = self
        hoursEdited.delegate = self
        descriptionEdited.delegate = self
        //Prevent paste into textField
        hoursEdited.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        rateEdited.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        descriptionEdited.smartInsertDeleteType = UITextSmartInsertDeleteType.no
        loadData()
    }
    
    
    
//MARK: - Load data from selected cell
    
    func loadData(){
        dateFormatter.dateStyle = DateFormatter.Style.long
        
        if let date = dateFormatter.date(from: selectedDay.dayName){
            workDayEdited.setDate(date, animated: true)
        }
        rateEdited.text = String(selectedDay.dayPay)
        hoursEdited.text = String(selectedDay.dayOrHourly)
        descriptionEdited.text = selectedDay.dayDescription
        
        if dailyOrHourlyCheck == nil {
            hoursEdited.isHidden = true
            hoursEdited.text = "1"
            segmentControl.selectedSegmentIndex = 0
        } else {
            if dailyOrHourlyCheck == 1 || dailyOrHourlyCheck == -1{
                hourDailyLabel.text = "Hours"
                hoursEdited.isHidden = false
                segmentControl.setEnabled(false, forSegmentAt: 0)
                segmentControl.selectedSegmentIndex = dailyOrHourlyCheck!
            } else {
                hoursEdited.isHidden = true
                hoursEdited.text = "1"
                segmentControl.setEnabled(false, forSegmentAt: 1)
                segmentControl.selectedSegmentIndex = dailyOrHourlyCheck!
            }
        }
        
    }
    
//MARK: - Textfield Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Character Checking Textfield
        if textField == rateEdited || textField == hoursEdited{
            let invalidCharacters = CharacterSet(charactersIn: "0123456789.").inverted
            return string.rangeOfCharacter(from: invalidCharacters) == nil
        } else {
            guard let textFieldCharacters = descriptionEdited.text else {
                return false
            }
            let count = textFieldCharacters.count + string.count
            return count <= 25
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Done button closes keyboard
        if textField == descriptionEdited{
            textField.resignFirstResponder()
            rateEdited.becomeFirstResponder()
        } else if textField == rateEdited {
            textField.resignFirstResponder()
            if segmentControl.selectedSegmentIndex != 1{
                textField.becomeFirstResponder()
            } else {
                hoursEdited.resignFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
//MARK: - UpdateButton Pressed
    
    @IBAction func updatePressed(_ sender: UIButton) {
        if hoursEdited.text != "" && rateEdited.text != ""{
            updateData()
            reloadView()
        } else {
            hoursEdited.placeholder = "Enter a Value"
            rateEdited.placeholder = "Enter a Rate"
        }
    }
    
    //MARK: - Reload TableView and Dismiss Modal
    
    func reloadView() {
        weeklyInstance.tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    func updateData(){
        do {
            try realm.write {
                dateFormatter.dateStyle = DateFormatter.Style.medium
                let stringDate = dateFormatter.string(from: workDayEdited.date)
                
                // Write into Realm
                selectedDay.dayName = stringDate
                selectedDay.dayDate = workDayEdited.date
                selectedDay.dayIndex = segmentControl.selectedSegmentIndex
                
                if let hoursAsDouble = Double(hoursEdited.text!), let rateAsDouble = Double(rateEdited.text!){
                    selectedDay.dayOrHourly = hoursAsDouble
                    selectedDay.dayPay = rateAsDouble
                    
                    var dayTotal: Double {
                        return hoursAsDouble * rateAsDouble
                    }
                    
                    selectedDay.dayTotal = dayTotal
                    selectedDay.dayDescription = descriptionEdited.text ?? ""
                    
                }
            }
        } catch {
            print("Error saving new days, \(error)")
        }
    }
    
    
    
}
