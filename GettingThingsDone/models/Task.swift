//
//  Task.swift
//  GettingThingsDone
//
//  Created by T-Mobile on 02/05/18.
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

    func mapTaskObject(_ task: TaskDataModel) {
        self.name = task.name
        self.status = task.status
        self.history = NSKeyedArchiver.archivedData(withRootObject: task.history ?? "") as NSData
    }
    
    func getDataModelObject() -> TaskDataModel{
        
        let taskModel = TaskDataModel()
        taskModel.name = name
        taskModel.status = status
        if let da = NSKeyedUnarchiver.unarchiveObject(with: Data(referencing: history!)) {
            print("FFFF = \(da)")
        }
        print("data = \(String(describing: NSKeyedUnarchiver.unarchiveObject(with: history! as Data)))")
        print("string arr  = \(String(describing: NSKeyedUnarchiver.unarchiveObject(with: history! as Data) as? [String])))")

        taskModel.history = NSKeyedUnarchiver.unarchiveObject(with: history! as Data) as? [String]
        return taskModel
    }
}
