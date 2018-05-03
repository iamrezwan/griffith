//
//  HomeViewModel.swift
//  GettingThingsDone
//
//  Created by Pravin G on 02/05/18.
//

import UIKit

enum TaskType :String {
    case InProgress = "Yet To Do"
    case Completed = "Completed"
}

class HomeViewModel: NSObject {
    public var inprogress_tasks: [TaskDataModel]?
    public var completed_tasks: [TaskDataModel]?

    
    func saveNewTaskToDB (_ taskName: String,onCompletion: @escaping (Bool) -> Void) {
        let task = TaskDataModel()
        task.name = taskName
        task.status = TaskType.InProgress.rawValue
        task.history = [String]()
        DataManager.sharedManager.saveTask(task) { (success) in
            onCompletion(success)
        }
    }
    
    func fetchAllIprogressTask (onCompletion: @escaping (Bool) -> Void) {
        DataManager.sharedManager.fetchInProgressTasks { (tasksModels) in
            self.inprogress_tasks = tasksModels
            onCompletion(true)
        }
    }
    
    func fetchAllCompletedTask (onCompletion: @escaping (Bool) -> Void) {
        DataManager.sharedManager.fetchCompletedTasks { (tasksModels) in
            self.completed_tasks = tasksModels
            onCompletion(true)
        }
    }
    
    func updateTask (_ task: TaskDataModel,name:String,onCompletion: @escaping (Bool) -> Void) {
        DataManager.sharedManager.updateTask(task, name: name) { (flag) in
            onCompletion(flag)
        }
    }
    
    func updateStatusForTask (_ task: TaskDataModel,status:String,onCompletion: @escaping (Bool) -> Void) {
        DataManager.sharedManager.updateStatusForTask(task, status: status) { (flag) in
            onCompletion(flag)
        }
    }
    
    func deleteTask (_ task: TaskDataModel,onCompletion: @escaping (Bool) -> Void) {
        DataManager.sharedManager.deleteTask(task) { (flag) in
            onCompletion(flag)
        }
    }
}

