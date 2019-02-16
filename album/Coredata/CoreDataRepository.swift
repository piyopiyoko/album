//
//  CoreDataRepository.swift
//  album
//
//  Created by hiyoko on 2019/02/16.
//  Copyright © 2019年 hiyoko. All rights reserved.
//

import UIKit
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
    
    func insert<T>(entityName: String, fetchRequest: NSFetchRequest<T>?, predicate: NSPredicate?, relationName: String?, params: (key: String, value: Any)...) -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: viewContext)
        let newRecord = NSManagedObject(entity: entity!, insertInto: viewContext)
        var id = 0
        if entityName == "Picture" {
            id = getRecipeLastId()
        }
        else {
            id = getLastId()
        }
        newRecord.setValue(id, forKey: "id")
        let order = getMaxOrder()
        newRecord.setValue(order, forKey: "order")
        
        for param in params {
            newRecord.setValue(param.value, forKey: param.key)
        }
        
        if let request = fetchRequest, let p = predicate, let relation = relationName {
            request.predicate = p
            let fetchData = try! viewContext.fetch(request)
            if(!fetchData.isEmpty) {
                newRecord.setValue(fetchData[0], forKey: relation)
            }
        }
        
        do {
            try viewContext.save()
        } catch {
        }
        
        return id
    }
    
    func load<T: AnyObjectModel>(predicate: NSPredicate? = nil, sortDescriptor: NSSortDescriptor? = nil) -> [T] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        query?.predicate = predicate
        if let sort = sortDescriptor {
            query?.sortDescriptors = [sort]
        }
        else {
            query?.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        }
        
        var dictionary = [T]()
        do {
            let fetchResults = try viewContext.fetch(query!)
            for result: AnyObject in fetchResults {
                dictionary.append(T(obj: result))
            }
        } catch {
        }
        
        return dictionary
    }
    
    private func getLastId() -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        var lastId: Int = 0
        do {
            let sortDesc = NSSortDescriptor(key: "id", ascending: false)
            query?.sortDescriptors = [sortDesc]
            
            let fetchResults = try viewContext.fetch(query!)
            if let id: Int = fetchResults[0].value(forKey: "id") as? Int {
                lastId = id
            }
        } catch {
        }
        
        return lastId + 1
    }
    
    private func getRecipeLastId() -> Int {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Picture> = Picture.fetchRequest()
        
        var lastId: Int = 0
        do {
            let fetchResults = try viewContext.fetch(query)
            for result: AnyObject in fetchResults {
                let id: Int = result.value(forKey: "id") as! Int
                if(id > lastId) {
                    lastId = id
                }
            }
        } catch {
        }
        
        return lastId + 1
    }
    
    private func getMaxOrder() -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        
        var maxOrder: Int = 0
        do {
            
            let sortDesc = NSSortDescriptor(key: "order", ascending: false)
            query?.sortDescriptors = [sortDesc]
            
            let fetchResults = try viewContext.fetch(query!)
            if fetchResults.count > 0 {
                if let order = fetchResults[0].value(forKey: "order") as? Int {
                    maxOrder = order
                }
            }
        } catch {
        }
        
        return maxOrder + 1
    }
}
