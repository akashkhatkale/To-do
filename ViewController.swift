//
//  ViewController.swift
//  todo
//
//  Created by Akash Khatkale on 14/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // winning outlets
    @IBOutlet weak var trophyImage: UIImageView!
    @IBOutlet weak var productiveText: UILabel!
    @IBOutlet weak var productiveDayText: UILabel!
    @IBOutlet weak var awesomeText: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var player : AVAudioPlayer!
    
    var tasks : [Tasks] = []
    var completedTasks : [CompletedTasks] = []
    var isCompleted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting the default theme as purple
        let launchFirst = UserDefaults.standard.bool(forKey: "launch")
        if launchFirst {
        }else {
            UserDefaults.standard.set("Purple", forKey: "theme")
            UserDefaults.standard.setValue(true, forKey: "launch")
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let result = formatter.string(from: date)
            UserDefaults.standard.set(result, forKey: "date")
            
            
        }
        
        // Tableview methods
        tableView.delegate = self
        tableView.dataSource = self
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        let previousDate = UserDefaults.standard.value(forKey: "date") as! String
        
        if previousDate != currentDate {
            //print("Date has changed")
        }else{
            //print("Date has not changed")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get the CoreData
        getData()
        // Reload the tableview
        tableView.reloadData()
        // settings the images
        let theme = UserDefaults.standard.string(forKey: "theme")!
        addButton.setImage(UIImage(named: "Add\(theme)"), for: .normal)
        addButton.setImage(UIImage(named: "AddClicked\(theme)"), for: .highlighted)
        trashButton.setImage(UIImage(named: "deleted\(theme)"), for: .normal)
        trashButton.setImage(UIImage(named: "deletedClicked\(theme)"), for: .highlighted)
        doneButton.setImage(UIImage(named: "done\(theme)"), for: .normal)
        doneButton.setImage(UIImage(named: "doneClicked\(theme)"), for: .highlighted)
        
        // Calling taskcompleted
        tasksCompleted()
        
    }
    
    
    func tasksCompleted(){
        // Checking if the tasks is empty or not
        if tasks.count == 0 {
            // You completed all the tasks
            print("You completed the tasks")
            trophyImage.isHidden = false
            productiveText.isHidden = false
            productiveDayText.isHidden = false
            awesomeText.isHidden = false
            star1.isHidden = false
            star2.isHidden = false
            tableView.isHidden = true
        }else {
            // You are pending with the taks
            print("You are pending with \(tasks.count) tasks")
            trophyImage.isHidden = true
            productiveText.isHidden = true
            productiveDayText.isHidden = true
            awesomeText.isHidden = true
            star1.isHidden = true
            star2.isHidden = true
            tableView.isHidden = false
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomCellTableViewCell
        let task = tasks[indexPath.row]
        let theme = UserDefaults.standard.string(forKey: "theme")!
        
        
        // Set the task name and its important
        cell.taskName.text = task.name
        cell.taskBorder.image = UIImage(named: "taskBorder\(theme)")
        
        if task.isImportant {
            cell.importantImage.isHidden = false
            if theme == "Orange"{
                cell.importantImage.backgroundColor = UIColor(red: 0.86, green: 0.52, blue: 0.035, alpha: 1)
            }else if theme == "Purple"{
                cell.importantImage.backgroundColor = UIColor(red: 0.70, green: 0.50, blue: 0.80, alpha: 1)
            }else if theme == "Blue"{
                cell.importantImage.backgroundColor = UIColor(red: 0.035, green: 0.63, blue: 0.74, alpha: 1)
            }else if theme == "Greenblue"{
                cell.importantImage.backgroundColor = UIColor(red: 0.0011, green: 0.72, blue: 0.58, alpha: 1)
            }else if theme == "Yellow"{
                cell.importantImage.backgroundColor = UIColor(red: 0.85, green: 0.71, blue: 0.13, alpha: 1)
            }else if theme == "Gray"{
                cell.importantImage.backgroundColor = UIColor(red: 0.37, green: 0.37, blue: 0.37, alpha: 1)
            }else if theme == "Green"{
                cell.importantImage.backgroundColor = UIColor(red: 0.52, green: 0.72, blue: 0.023, alpha: 1)
            }
            cell.taskName.textColor = UIColor.white
            if let category = task.category {
                cell.categoryImage.image = UIImage(named: "\(category)White.png")
            }
        }else {
            cell.importantImage.isHidden = true
            let theme = UserDefaults.standard.string(forKey: "theme")!
            if theme == "Orange"{
                cell.importantImage.backgroundColor = UIColor(red: 0.92, green: 0.62, blue: 0.043, alpha: 1)
            }else if theme == "Purple"{
                cell.importantImage.backgroundColor = UIColor(red: 0.78, green: 0.57, blue: 0.87, alpha: 1)
            }else if theme == "Blue"{
                cell.importantImage.backgroundColor = UIColor(red: 0.047, green: 0.72, blue: 0.82, alpha: 1)
            }else if theme == "Greenblue"{
                cell.importantImage.backgroundColor = UIColor(red: 0.007, green: 0.83, blue: 0.66, alpha: 1)
            }else if theme == "Yellow"{
                cell.importantImage.backgroundColor = UIColor(red: 0.91, green: 0.8, blue: 0.87, alpha: 1)
            }else if theme == "Gray"{
                cell.importantImage.backgroundColor = UIColor(red: 0.47, green: 0.46, blue: 0.46, alpha: 1)
            }else if theme == "Green"{
                cell.importantImage.backgroundColor = UIColor(red: 0.58, green: 0.81, blue: 0.027, alpha: 1)
            }
            cell.taskName.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            if let category = task.category {
                cell.categoryImage.image = UIImage(named: "\(category).png")
            }
        }
        
        let date = Date()
        if let reminder = task.reminder {
            if reminder < date {
                cell.importantImage.isHidden = false
                cell.importantImage.backgroundColor = UIColor(red: 0.98, green: 0.37, blue: 0.43, alpha: 1)
                cell.taskBorder.image = UIImage(named: "taskBorderRed.png")
                cell.taskName.textColor = UIColor.white
                if let category = task.category {
                    cell.categoryImage.image = UIImage(named: "\(category)White.png")
                }
            }
            // setting the alarm image
            if task.isImportant {
                cell.alarmImage.image = UIImage(named: "alarmFavorite.png")
            }else {
                cell.alarmImage.image = UIImage(named: "alarm.png")
            }
        }
        
        print("Addition date = \(task.dateOfAddition!)")
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Delete swipe
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let task = self.tasks[indexPath.row]
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                self.tasks = try context.fetch(Tasks.fetchRequest())
            }catch {
                print("Fetching failed")
            }
            tableView.reloadData()
            
            // show the trophy when count is zero
            if self.tasks.count == 0 {
                self.tasksCompleted()
                let url = Bundle.main.url(forResource: "Spring", withExtension: "mp3")
                do {
                    // Play sound
                    self.player = try AVAudioPlayer(contentsOf: url!)
                    self.player.prepareToPlay()
                }catch {
                    print("Fetching failed")
                }
                self.player.play()
            }
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "deleted")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Done swipe
        let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completionHandler) in
            let task = self.tasks[indexPath.row]
            let url = Bundle.main.url(forResource: "Ended", withExtension: "mp3")
            
            // Setting up the CoreData and saving
            let completedTask = CompletedTasks(context: context)
            completedTask.name = task.name
            completedTask.note = task.note
            
            // remove the item
            context.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                self.tasks = try context.fetch(Tasks.fetchRequest())
                self.completedTasks = try context.fetch(CompletedTasks.fetchRequest())
                // Play sound
                self.player = try AVAudioPlayer(contentsOf: url!)
                self.player.prepareToPlay()
            }catch {
                print("Fetching failed")
            }
            self.player.play()
            
            // show the trophy when count is zero
            if self.tasks.count == 0 {
                self.tasksCompleted()
                let url = Bundle.main.url(forResource: "Spring", withExtension: "mp3")
                do {
                    // Play sound
                    self.player = try AVAudioPlayer(contentsOf: url!)
                    self.player.prepareToPlay()
                }catch {
                    print("Fetching failed")
                }
                self.player.play()
            }
            
            // Other code
            tableView.reloadData()
            completionHandler(true)
            
        }
        doneAction.image = UIImage(named: "done")
        
        let theme = UserDefaults.standard.string(forKey: "theme")!
        if theme == "Orange"{
            doneAction.backgroundColor = UIColor(red: 0.92, green: 0.62, blue: 0.043, alpha: 1)
        }else if theme == "Purple"{
            doneAction.backgroundColor = UIColor(red: 0.78, green: 0.57, blue: 0.87, alpha: 1)
        }else if theme == "Blue"{
            doneAction.backgroundColor = UIColor(red: 0.047, green: 0.72, blue: 0.82, alpha: 1)
        }else if theme == "Greenblue"{
            doneAction.backgroundColor = UIColor(red: 0.007, green: 0.83, blue: 0.66, alpha: 1)
        }else if theme == "Yellow"{
            doneAction.backgroundColor = UIColor(red: 0.91, green: 0.8, blue: 0.14, alpha: 1)
        }else if theme == "Gray"{
            doneAction.backgroundColor = UIColor(red: 0.47, green: 0.46, blue: 0.46, alpha: 1)
        }else if theme == "Green"{
            doneAction.backgroundColor = UIColor(red: 0.58, green: 0.81, blue: 0.027, alpha: 1)
        }
        
        let date = Date()
        if let reminder = tasks[indexPath.row].reminder {
            if reminder < date {
                doneAction.backgroundColor = UIColor(red: 0.98, green: 0.37, blue: 0.43, alpha: 1)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    
    
    func cancelNotifications(){
        // Cancelling notifications
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification:UNNotificationRequest in notificationRequests {
                identifiers.append(notification.identifier)
                print(notification.identifier)
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskSelectedSegue", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SelectedTaskViewController{
            destination.taskName = tasks[(tableView.indexPathForSelectedRow?.row)!].name!
            if let note = tasks[(tableView.indexPathForSelectedRow?.row)!].note{
                destination.taskNote = note
            }
            destination.isImportant = tasks[(tableView.indexPathForSelectedRow?.row)!].isImportant
            destination.categoryName = tasks[(tableView.indexPathForSelectedRow?.row)!].category!
            destination.sound = tasks[(tableView.indexPathForSelectedRow?.row)!].sound!
            destination.selectedIndex = (tableView.indexPathForSelectedRow?.row)!
        }
    }
    
    @IBAction func deletedClicked(_ sender: Any) {
        if tasks.count > 0 {
            displayAlert(message: "Do you want to delete all the tasks?")
            isCompleted = false
        }
    }
    
    
    @IBAction func completedClicked(_ sender: Any) {
        if tasks.count > 0 {
            displayAlert(message: "Do you want to complete all the tasks?")
            isCompleted = true
        }
    }
    
    
    func displayAlert(message : String){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let alertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            if self.isCompleted{
                // Complete all the tasks
                for result in self.tasks {
                    // Setting up completed tasks
                    let completedTask = CompletedTasks(context: context)
                    completedTask.name = result.name
                    completedTask.note = result.note
                    // Delete the task
                    context.delete(result)
                    self.cancelNotifications()
                    // Saving the coredata
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    // Fetching the data
                    do {
                        self.tasks = try context.fetch(Tasks.fetchRequest())
                        self.completedTasks = try context.fetch(CompletedTasks.fetchRequest())
                    }catch {
                        print("Fetching failed")
                    }
                    self.tasksCompleted()
                    let url = Bundle.main.url(forResource: "Spring", withExtension: "mp3")
                    do {
                        // Play sound
                        self.player = try AVAudioPlayer(contentsOf: url!)
                        self.player.prepareToPlay()
                    }catch {
                        print("Fetching failed")
                    }
                    self.player.play()
                    self.tableView.reloadData()
                }
            }else {
                // Delete all the tasks
                for result in self.tasks {
                    context.delete(result)
                    self.cancelNotifications()
                    // Saving the coredata
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    // Fetching the data
                    do {
                        self.tasks = try context.fetch(Tasks.fetchRequest())
                    }catch {
                        print("Fetching failed")
                    }
                    self.tasksCompleted()
                    let url = Bundle.main.url(forResource: "Spring", withExtension: "mp3")
                    do {
                        // Play sound
                        self.player = try AVAudioPlayer(contentsOf: url!)
                        self.player.prepareToPlay()
                    }catch {
                        print("Fetching failed")
                    }
                    self.player.play()
                    self.tableView.reloadData()
                }
            }
            
        }
        alertController.addAction(okAction)
        alertController.addAction(deleteAction)
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
    
}














