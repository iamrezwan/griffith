//
//  DataManager.swift
//  GettingThingsDone
//
//  Created by T-Mobile on 02/05/18.
//

import UIKit
import CoreData

class DataManager: NSObject {

    static let sharedManager = DataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    public func saveTask(_ task: TaskDataModel,onCompletion: @escaping (Bool) -> Void) {
        appDelegate.persistentContainer.viewContext.perform {
            let managedContext = self.appDelegate.persistentContainer.viewContext
            let taskEntity:Task = Task(entity: NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!, insertInto: managedContext)
            taskEntity.mapTaskObject(task)
            do {
                try managedContext.save()
                onCompletion(true)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                onCompletion(false)
            }
        }
    }
    
    public func fetchTasks(onCompletion: @escaping ([TaskDataModel]?) -> Void) {
        appDelegate.persistentContainer.viewContext.perform {
            let userTasks = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            let managedContext = self.appDelegate.persistentContainer.viewContext
            
            do {
                let tasks:[Task] = try managedContext.fetch(userTasks) as! [Task]
                let tasksArr =  tasks.map({ (task) -> TaskDataModel in
                    return task.getDataModelObject()
                })
            onCompletion(tasksArr)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                onCompletion(nil)
            }
        }
    }
    
    public func fetchInProgressTasks(onCompletion: @escaping ([TaskDataModel]?) -> Void) {
        appDelegate.persistentContainer.viewContext.perform {
            let userTasks = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            let managedContext = self.appDelegate.persistentContainer.viewContext
            
            let predicate = NSPredicate(format: "status == %@", "Yet To Do")

            userTasks.predicate = predicate

            do {
                let tasks:[Task] = try managedContext.fetch(userTasks) as! [Task]
                let tasksArr =  tasks.map({ (task) -> TaskDataModel in
                    return task.getDataModelObject()
                })
                onCompletion(tasksArr)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                onCompletion(nil)
            }
        }
    }
    
    public func fetchCompletedTasks(onCompletion: @escaping ([TaskDataModel]?) -> Void) {
        appDelegate.persistentContainer.viewContext.perform {
            let userTasks = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            let managedContext = self.appDelegate.persistentContainer.viewContext
            
            let predicate = NSPredicate(format: "status == %@", "Completed")
            userTasks.predicate = predicate
            
            do {
                let tasks:[Task] = try managedContext.fetch(userTasks) as! [Task]
                let tasksArr =  tasks.map({ (task) -> TaskDataModel in
                    return task.getDataModelObject()
                })
                onCompletion(tasksArr)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                onCompletion(nil)
            }
        }
    }
}

