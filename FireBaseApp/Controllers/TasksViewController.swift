//
//  TasksViewController.swift
//  FireBaseApp
//
//  Created by Ilnur on 30.07.2023.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: Person!
    var ref: DatabaseReference!
    var tasks = Array<Task>()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Person(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.textLabel?.text = "This is cell number \(indexPath.row)"
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(
            title: "New Task",
            message: "Add new task",
            preferredStyle: .alert
        )
        alertController.addTextField()
        let save = UIAlertAction(
            title: "Save",
            style: .default) { [weak self] _ in
                guard let textField =
                        alertController.textFields?.first, textField.text != "" else { return }
                let task = Task(title: textField.text!, userId: (self?.user.uid)!)
                let taskRef = self?.ref.child(task.title.lowercased())
                taskRef?.setValue(task.convertToDictionary())
            }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func SignOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
}
