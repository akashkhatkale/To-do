//
//  SelectedTaskViewController.swift
//  todo
//
//  Created by Akash Khatkale on 15/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class SelectedTaskViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var favoriteImage: UIButton!
    @IBOutlet weak var reminderText: UITextField!
    @IBOutlet weak var soundText: UITextField!
    @IBOutlet weak var categoryText: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    
    var datePicker : UIDatePicker = UIDatePicker()
    var pickerView : UIPickerView = UIPickerView()
    var categoryPickerView : UIPickerView = UIPickerView()
    
    
    var tasks : [Tasks] = []
    
    
    var taskName : String = ""
    var taskNote : String = ""
    var sound : String = ""
    var categoryName : String = ""
    var isImportant = false
    var noteIsEmpty = false
    var selectedIndex = 0
    
    var sounds : [String] = ["Christmas","Bubbling","Closure","Confident","Boom","Exquisite","Jingle bell","Light","Ocean","Ended","Impressed","To the point","Unconvinced","Unsure","Spring"]
    var category : [String] = ["Default","Work", "Call","Check","Email","Shop","Meet","Clean","Send","Pay","Pick","Drink","Read","Study","Swim","Ride","Play","Exercise","Walk","Meditate","Music","Hangout","Eat","Drive","Sports"]
    var player : AVAudioPlayer!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return sounds.count
        }else {
            return category.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return sounds[row]
        }else {
            return category[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            let url = Bundle.main.url(forResource: sounds[row], withExtension: "mp3")
            do {
                player = try AVAudioPlayer(contentsOf: url!)
                player.prepareToPlay()
            }catch let error as NSError{
                print(error)
            }
            soundText.text = sounds[row]
            player.play()
        } else {
            categoryText.text = category[row]
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        // Pickerview
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        pickerView.tag = 1
        categoryPickerView.tag = 2
        
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.addTarget(self, action: #selector(AddTodoViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        
        // Setting uipicker when sound ,reminder and category is tapped
        reminderText.inputView = datePicker
        soundText.inputView = pickerView
        categoryText.inputView = categoryPickerView
        
        
        // Setting the task's name
        textField.text = taskName
        
        // Setting the task's note
        if taskNote != "" {
            // There is something in note
            textView.text = taskNote
            textView.textColor = UIColor.black
            noteIsEmpty = false
        }else {
            // Place the placeholder's text
            textView.text = "Write a note"
            textView.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
            noteIsEmpty = true
        }
        
        
        // Check if the task is important
        let theme = UserDefaults.standard.string(forKey: "theme")!
        if isImportant {
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .highlighted )
        }else{
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .highlighted )
        }
        
        // Check the reminder
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            tasks = try context.fetch(Tasks.fetchRequest())
        }catch {
            print("Fetching failed")
        }
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "ccc, d MMM hh:mm a"
        if let reminder = tasks[selectedIndex].reminder {
           let dateString1 = dateformatter1.string(from: reminder)
           reminderText.placeholder = dateString1
        }
        
        // Check the sounds
        if sound != ""{
            soundText.text = sound
        }
        
        // Check the category
        if categoryName != "" {
            categoryText.text = categoryName
        }
        
        // Adding tap recognizer to close the keyboard after clicking elsewhere on the screen
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    
    
    @objc func handleDatePicker(){
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "ccc, d MMM hh:mm a"
        let dateString1 = dateformatter1.string(from: datePicker.date)
        reminderText.text = dateString1
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        
        // set images
        let theme = UserDefaults.standard.string(forKey: "theme")!
        print(theme)
        yesButton.setImage(UIImage(named: "yes\(theme)"), for: .normal)
        yesButton.setImage(UIImage(named: "yesClicked\(theme)"), for: .highlighted)
    }
    
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if taskNote == "" {
            // Note is empty, clear the placeholder's text
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Write a note"
            textView.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        }
    }
    
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        if isImportant {
            // The task is not favorite
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .highlighted )
            isImportant = false
        }else{
            // The task is favorite
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .highlighted )
            isImportant = true
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        _ = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let task = tasks[selectedIndex].value(forKey: "name") as? String{
            if textField.text != "" {
                tasks[selectedIndex].setValue(textField.text!, forKey: "name")
                if textView.textColor != UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1){
                    tasks[selectedIndex].setValue(textView.text!, forKey: "note")
                }
                tasks[selectedIndex].setValue(isImportant, forKey: "isImportant")
                tasks[selectedIndex].setValue(categoryText.text!, forKey: "category")
                tasks[selectedIndex].setValue(soundText.text!, forKey: "sound")
                // check if the reminder has changed or not

                if reminderText.text != "" {
                    // reminder has modified
                    tasks[selectedIndex].setValue(datePicker.date, forKey: "reminder")
                    let dateformatter = DateFormatter()
                    dateformatter.dateFormat = "dd.M.yyyy"
                    let dateString = dateformatter.string(from: datePicker.date)
                    tasks[selectedIndex].setValue(dateString, forKey: "dateOfAddition")
                }
                
                // Cancelling notifications
                UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification:UNNotificationRequest in notificationRequests {
                        if notification.identifier == self.tasks[self.selectedIndex].uniqueId {
                            identifiers.append(notification.identifier)
                        }
                    }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
                }
                // Save the context
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                displayNotification()
                // Go back to main menu
                navigationController?.popViewController(animated: true)
            }else {
                print("Error")
                displayAlert(message: "Enter Something")
            }
        }
    }
    
    
    
    func displayNotification(){
        // create unique id
        let uniqueId = UUID().uuidString
        
        // Setting actions for notifications
        let action1 = UNNotificationAction(identifier: "action1", title: "Completed", options: UNNotificationActionOptions.foreground)
        let action2 = UNNotificationAction(identifier: "action2", title: "Delete", options: UNNotificationActionOptions.foreground)
        let category = UNNotificationCategory(identifier: "category", actions: [action1,action2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Setting notifications
        let calendar = Calendar.current
        let content = UNMutableNotificationContent()
        content.title = "Complete your To-Do"
        content.body = textField.text!
        content.sound = UNNotificationSound(named: "\(soundText.text!).mp3")
        
        content.categoryIdentifier = "category"
        
        let components = calendar.dateComponents([.day,.hour,.minute], from: self.datePicker.date)
        let calenderTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: "\(uniqueId)", content: content, trigger: calenderTrigger)
        tasks[selectedIndex].setValue(uniqueId, forKey: "uniqueId")
        UNUserNotificationCenter.current().add(request)
    }
    
    
    
    
    func displayAlert(message : String){
        // Alert controller
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            tasks = try context.fetch(Tasks.fetchRequest())
        }catch {
            print("Fetching failed")
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
