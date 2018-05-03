//
//  Task.swift
//  GettingThingsDone
//
//  Created by Pravin G on 02/05/18.
//

import UIKit
import CoreData

public class Task: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var history: NSData?

    //Map Datamodel to task managed object
    func mapTaskObject(_ task: TaskDataModel) {
        self.name = task.name
        self.status = task.status
        self.history = NSKeyedArchiver.archivedData(withRootObject: task.history ?? "") as NSData
    }
    
    //Map task managed object to datamodel
    func getDataModelObject() -> TaskDataModel{
        
        let taskModel = TaskDataModel()
        taskModel.name = name
        taskModel.status = status
        taskModel.history = NSKeyedUnarchiver.unarchiveObject(with: history! as Data) as? [String]
        return taskModel
    }
}
