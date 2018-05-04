//
//  ToDoItemDetailVC.swift
//  GettingThingsDone
//
//  Created by Pravin G on 02/05/18.
//

import UIKit


class ToDoItemDetailVC: UIViewController, UITextFieldDelegate {
    
    public var task: TaskDataModel?
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let task = task {
            taskTextField.text = task.name
        } else {
            taskTextField.text = "To Do Item"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let task = task {
            DataManager.sharedManager.updateTask(task, name: self.taskTextField.text!) { (flag) in  }
        } else {
            let newTask = TaskDataModel()
            newTask.name = taskTextField.text
            newTask.status = TaskType.InProgress.rawValue
            newTask.history = [String]()
            DataManager.sharedManager.saveTask(newTask) { (success) in}
        }
    }
    //MARK:- Private Methods
    func configureUI() {
    }
    
    //MARK:- UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskTextField {
            textField.resignFirstResponder()
            DataManager.sharedManager.updateTask(task!, name: self.taskTextField.text!) { (flag) in  }
        }
        return true
    }
}
