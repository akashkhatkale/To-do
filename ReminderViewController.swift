////
////  ReminderViewController.swift
////  todo
////
////  Created by Akash Khatkale on 16/03/1940 Saka.
////  Copyright © 1940 Akash Khatkale. All rights reserved.
////
//
//import UIKit
//
//class ReminderViewController: UIViewController {
//    
//    
//    @IBOutlet weak var datePicker: UIDatePicker!
//    
//    var reminderText = ""
//    var reminder = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Properties
//        datePicker.addTarget(self, action: #selector(ReminderViewController.addDate), for: UIControlEvents.valueChanged)
//        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
//        
//        // Asking user for notifications
//        
////
//        
//        // Adding tap recognizer to close the keyboard after clicking elsewhere on the screen
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        view.endEditing(true)
//    }
//    
//    @objc func addDate() {
//        
//    }
//
//    @IBAction func doneClicked(_ sender: Any) {
//        reminder = "\(self.datePicker.date)"
//        navigationController?.popViewController(animated: true)
//    }
//    
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
