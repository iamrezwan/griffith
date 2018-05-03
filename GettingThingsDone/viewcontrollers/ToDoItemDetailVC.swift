//
//  ToDoItemDetailVC.swift
//  GettingThingsDone
//
//  Created by T-Mobile on 02/05/18.
//

import UIKit

class ToDoItemDetailVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
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
        }
        return true
    }
}
