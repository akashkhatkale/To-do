//
//  CompletedViewController.swift
//  todo
//
//  Created by Akash Khatkale on 15/03/1940 Saka.
//  Copyright © 1940 Akash Khatkale. All rights reserved.
//

import UIKit

class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var completedTasks : [CompletedTasks] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Get the CoreData
        getData()
        
        // Reload the tableview
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 61
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "completedCell") as! CompletedTasksTableViewCell
        let completedTask = completedTasks[indexPath.row]
        
        // Set the task name and its important
        cell.taskName.text = completedTask.name
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Delete swipe
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            if indexPath.row >= 1 {
              let task = self.completedTasks[indexPath.row - 1]
                context.delete(task)
            } else {
              let task = self.completedTasks[indexPath.row]
                context.delete(task)
            }
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                self.completedTasks = try context.fetch(CompletedTasks.fetchRequest())
            }catch {
                print("Fetching failed")
            }
            
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "deleted")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func getData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            completedTasks = try context.fetch(CompletedTasks.fetchRequest())
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
