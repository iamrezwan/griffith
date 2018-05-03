//
//  HomeVC.swift
//  GettingThingsDone
//
//  Created by Pravin G on 02/05/18.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource,UITableViewDelegate  {

    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var viewModel = HomeViewModel()

    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAllCompletedTask { (success) in }
        viewModel.fetchAllIprogressTask{ (success) in }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK:- Private Methods
    func configureUI() {
        self.title = "Things To Do"
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        if(tableView.isEditing == true) {
            
            let btn: UIBarButtonItem = navigationItem.leftBarButtonItems![0]
            self.tableView.isEditing = false
            btn.title = "Edit"
        } else {
            tableView.isEditing = true
            let btn: UIBarButtonItem = navigationItem.leftBarButtonItems![0]
            btn.title = "Done"
        }
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Add ToDo Item", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter ToDo Item"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.viewModel.saveNewTaskToDB(firstTextField.text!, onCompletion: { (success) in
                if success {
                    self.viewModel.fetchAllIprogressTask(onCompletion: { (success) in
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                }
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
    
        return ((section == 0) ? viewModel.inprogress_tasks?.count ?? 0 : viewModel.completed_tasks?.count ?? 0)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return (section == 0) ? "Yet To Do" : "Completed"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (indexPath.section == 0) {
            let task = viewModel.inprogress_tasks![indexPath.row]
            cell.textLabel?.text =  task.name
        } else {
            let task = viewModel.completed_tasks![indexPath.row]
            cell.textLabel?.text =  task.name
        }

        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "ToDoItemDetailVC") as! ToDoItemDetailVC
        detailVC.viewModel = viewModel
        if indexPath.section == 0 {
            detailVC.task = viewModel.inprogress_tasks?[indexPath.row]
        } else {
            detailVC.task = viewModel.completed_tasks?[indexPath.row]
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if (destinationIndexPath.section == 1 && sourceIndexPath.section == 0) {
            viewModel.updateStatusForTask(viewModel.inprogress_tasks![sourceIndexPath.row], status: "Completed") { (flag) in }
            viewModel.completed_tasks?.insert(viewModel.inprogress_tasks![sourceIndexPath.row] , at: destinationIndexPath.row)
        } else if (destinationIndexPath.section == 0 && sourceIndexPath.section == 1){
            viewModel.updateStatusForTask(viewModel.inprogress_tasks![sourceIndexPath.row], status: "Yet To Do") { (flag) in }
            viewModel.inprogress_tasks?.insert(viewModel.completed_tasks![sourceIndexPath.row], at: destinationIndexPath.row)
        }
        

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0) {
                viewModel.deleteTask(viewModel.inprogress_tasks![indexPath.row]) { (flag) in }
                viewModel.inprogress_tasks?.remove(at: indexPath.row)
            } else {
                viewModel.deleteTask(viewModel.completed_tasks![indexPath.row]) { (flag) in }
                viewModel.completed_tasks?.remove(at: indexPath.row)
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
}
