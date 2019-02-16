//
//  CoreDataRepository.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import Foundation
import CoreData

class CoreDataRepository<T: NSManagedObject> {
    
    let query: NSFetchRequest<T>?
    
    init(query: NSFetchRequest<T>) {
        self.query = query
    }
    
    func insert(entityName: String, params: (key: String, value: Any)...) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
        let newRecord = NSManagedObject(entity: entity!, insertInto: viewContext)
        let id = getLastId()
        newRecord.setValue(id, forKey: "id")
        let order = getMaxOrder()
        newRecord.setValue(order, forKey: "order")
        
        for param in params {
            newRecord.setValue(param.value, forKey: param.key)
        }
        
        do {
            try viewContext.save()
        } catch {
        }
        
        return id
    }
}
