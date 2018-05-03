//
//  ToDoItemDetailVC.swift
//  GettingThingsDone
//
//  Created by T-Mobile on 02/05/18.
//

import UIKit

class ToDoItemDetailVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var viewModel:HomeViewModel?
    
    public var task: TaskDataModel?
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taskTextField.text = task?.name
    }
    
    //MARK:- Private Methods
    func configureUI() {
        self.title = "Things To Do"
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter ToDo Item"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.viewModel?.saveNewTaskToDB(firstTextField.text!, onCompletion: { (success) in
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:- UITablview Delegate/DataSource Methods Methods
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let t = task, let history = t.history {
            return history.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        if let t = task {
            cell.textLabel?.text = t.history?[indexPath.row]
        }
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK:- UITextField delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == taskTextField {
            textField.resignFirstResponder()
            if let vm = viewModel {
                vm.updateTask(task!, name: self.taskTextField.text!) { (success) in }
            }
        }
        return true
    }
}
