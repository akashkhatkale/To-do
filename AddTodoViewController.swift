//
//  AddTodoViewController.swift
//  todo
//
//  Created by Akash Khatkale on 14/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class AddTodoViewController: UIViewController, UITextViewDelegate, UNUserNotificationCenterDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var taskView: UITextField!
    @IBOutlet weak var noteView: UITextView!
    @IBOutlet weak var favoriteImage: UIButton!
    @IBOutlet weak var reminderText: UITextField!
    @IBOutlet weak var soundTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var isFavorite = false
    var isReminder = false
    var datePicker : UIDatePicker = UIDatePicker()
    var pickerView : UIPickerView = UIPickerView()
    var categoryPickerView : UIPickerView = UIPickerView()
    var sounds : [String] = ["Christmas","Bubbling","Closure","Confident","Boom","Exquisite","Jingle bell","Light","Ocean","Ended","Impressed","To the point","Unconvinced","Unsure","Spring"]
    var category : [String] = ["Default","Work", "Call","Check","Email","Shop","Meet","Clean","Send","Pay","Drink","Read","Study","Swim","Ride","Play","Exercise","Walk","Meditate","Music","Hangout","Eat","Drive","Sports"]
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
            soundTextField.text = sounds[row]
            player.play()
        } else {
            categoryTextField.text = category[row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pickerview
        pickerView.delegate = self
        pickerView.dataSource = self
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        pickerView.tag = 1
        categoryPickerView.tag = 2
        
        // Taskview and noteview
        taskView.becomeFirstResponder()
        noteView.delegate = self
        noteView.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        
        // Setting date picker when reminder is tapped
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        reminderText.inputView = datePicker
        datePicker.addTarget(self, action: #selector(AddTodoViewController.handleDatePicker), for: UIControlEvents.valueChanged)
        
        // Setting uipicker when sound and category is tapped
        soundTextField.inputView = pickerView
        categoryTextField.inputView = categoryPickerView
        
        // Adding tap recognizer to close the keyboard after clicking elsewhere on the screen
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Asking users for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (didAllowed, error) in
            if !didAllowed {
                print("Notifications allow denied")
            }else {
                print("Notifications allowed")
            }
        }
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        yesButton.setImage(UIImage(named: "yes\(theme)"), for: .normal)
        yesButton.setImage(UIImage(named: "yesClicked\(theme)"), for: .highlighted)
        
        favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .normal )
        favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .highlighted)
        
        if theme == "Orange"{
            cancelButton.setTitleColor(UIColor(red: 0.92, green: 0.62, blue: 0.043, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.86, green: 0.52, blue: 0.035, alpha: 1), for: .highlighted)
        }else if theme == "Purple"{
            cancelButton.setTitleColor(UIColor(red: 0.78, green: 0.57, blue: 0.87, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.70, green: 0.50, blue: 0.80, alpha: 1), for: .highlighted)
        }else if theme == "Blue"{
            cancelButton.setTitleColor(UIColor(red: 0.047, green: 0.72, blue: 0.82, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.035, green: 0.63, blue: 0.74, alpha: 1), for: .highlighted)
        }else if theme == "Greenblue"{
            cancelButton.setTitleColor(UIColor(red: 0.007, green: 0.83, blue: 0.66, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.0011, green: 0.72, blue: 0.58, alpha: 1), for: .highlighted)
        }else if theme == "Yellow"{
            cancelButton.setTitleColor(UIColor(red: 0.91, green: 0.8, blue: 0.14, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.85, green: 0.71, blue: 0.13, alpha: 1), for: .highlighted)
        }else if theme == "Gray"{
            cancelButton.setTitleColor(UIColor(red: 0.47, green: 0.46, blue: 0.46, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1), for: .highlighted)
        }else if theme == "Green"{
            cancelButton.setTitleColor(UIColor(red: 0.58, green: 0.81, blue: 0.027, alpha: 1), for: .normal)
            cancelButton.setTitleColor(UIColor(red: 0.52, green: 0.72, blue: 0.023, alpha: 1), for: .highlighted)
        }
    }
    
    
    @objc func handleDatePicker(){
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "ccc, d MMM hh:mm a"
        let dateString1 = dateformatter1.string(from: datePicker.date)
        reminderText.text = dateString1      
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK:- Textview delegate methods
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteView.textColor == UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1){
            noteView.text = nil
            noteView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteView.text == "" {
            noteView.text = "Write a note"
            noteView.textColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        }
    }
    
    
    
    // MARK:- Buttons clicked
    
    
    @IBAction func favoriteClicked(_ sender: Any) {
        let theme = UserDefaults.standard.string(forKey: "theme")!
        if isFavorite {
            // The task is not favorite
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favorite\(theme)"), for: .highlighted )
            isFavorite = false
        }else{
            // The task is favorite
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .normal )
            favoriteImage.setImage(UIImage(named: "favoriteClicked\(theme)"), for: .highlighted )
            isFavorite = true
        }
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        if taskView.text != "" {
            // Setting up CoreData
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = Tasks(context: context)
            let uId = UUID().uuidString
            
            // Setting up the date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.M.yyyy"
            let dateString = dateformatter.string(from: datePicker.date)

            
            // Setting the values of CoreData
            task.name = taskView.text!
            if noteView.textColor == UIColor.black{
                task.note = noteView.text!
            }
            task.isImportant = isFavorite
            if reminderText.text != "" {
               task.reminder = datePicker.date
            }
            if soundTextField.text != nil {
                task.sound = soundTextField.text
            }
            if categoryTextField.text != nil {
                task.category = categoryTextField.text
            }
            task.uniqueId = uId
            task.dateOfAddition = dateString
            
            // Saving the Coredata and displaying notifications
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            displayNotification(uniqueId : uId)
            // Go back to main menu
            dismiss(animated: true, completion: nil)
        }else {
            // Display Error message
            displayAlert(message: "Enter something")
        }
    }
    
    
    func displayNotification(uniqueId : String){
        // creating unique id
        
        // Setting actions for notifications
        let action1 = UNNotificationAction(identifier: "action1", title: "Completed", options: UNNotificationActionOptions.foreground)
        let action2 = UNNotificationAction(identifier: "action2", title: "Delete", options: UNNotificationActionOptions.foreground)
        let category = UNNotificationCategory(identifier: "category", actions: [action1,action2], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // Setting notifications
        let calendar = Calendar.current
        let content = UNMutableNotificationContent()
        content.title = "Complete your To-Do"
        content.body = taskView.text!
        content.sound = UNNotificationSound(named: "\(soundTextField.text!).mp3")
        
        content.categoryIdentifier = "category"
        
        let components = calendar.dateComponents([.day,.hour,.minute], from: self.datePicker.date)
        
        let calenderTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: uniqueId, content: content, trigger: calenderTrigger)
        print(uniqueId)
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "action1"
        {
            print("Completing the action")
        }else
        {
            print("Deleting the action")
        }
        completionHandler()
    }
    
    
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK:- Alert
    
    func displayAlert(message : String){
        // Alert controller
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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

