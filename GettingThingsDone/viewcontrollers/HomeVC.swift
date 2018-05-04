//
//  HomeVC.swift
//  GettingThingsDone
//
//  Created by Pravin G on 02/05/18.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource,UITableViewDelegate  {

    @IBOutlet weak var editBtn: UIBarButtonItem!
    

    var inprogress_tasks: [TaskDataModel]?
    var completed_tasks: [TaskDataModel]?

    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.sharedManager.fetchCompletedTasks { (tasksModels) in
            self.completed_tasks = tasksModels
        }
        DataManager.sharedManager.fetchInProgressTasks { (tasksModels) in
            self.inprogress_tasks = tasksModels
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK:- Private Methods
    func configureUI() {
        self.title = "Master"
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "ToDoItemDetailVC") as! ToDoItemDetailVC
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //MARK:- UITablview Delegate/DataSource Methods Methods

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return ((section == 0) ? inprogress_tasks?.count ?? 0 : completed_tasks?.count ?? 0)!

    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return (section == 0) ? "Yet To Do" : "Completed"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if (indexPath.section == 0) {
            let task = inprogress_tasks![indexPath.row]
            cell.textLabel?.text =  task.name
        } else {
            let task = completed_tasks![indexPath.row]
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
        if indexPath.section == 0 {
            detailVC.task = inprogress_tasks?[indexPath.row]
        } else {
            detailVC.task = completed_tasks?[indexPath.row]
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if (destinationIndexPath.section == 1 && sourceIndexPath.section == 0) {
            DataManager.sharedManager.updateStatusForTask(inprogress_tasks![sourceIndexPath.row], status: "Completed") { (flag) in
            }
            completed_tasks?.insert(inprogress_tasks![sourceIndexPath.row] , at: destinationIndexPath.row)
        } else if (destinationIndexPath.section == 0 && sourceIndexPath.section == 1){
            DataManager.sharedManager.updateStatusForTask(inprogress_tasks![sourceIndexPath.row], status: "Yet To Do") { (flag) in
            }
            inprogress_tasks?.insert(completed_tasks![sourceIndexPath.row], at: destinationIndexPath.row)
        }
        

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if (indexPath.section == 0) {
                DataManager.sharedManager.deleteTask(inprogress_tasks![indexPath.row]) { (flag) in}
                inprogress_tasks?.remove(at: indexPath.row)
            } else {
                DataManager.sharedManager.deleteTask(completed_tasks![indexPath.row]) { (flag) in}
                completed_tasks?.remove(at: indexPath.row)
            }
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
}
