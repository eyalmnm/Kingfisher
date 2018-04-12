//
//  CoreDataManager.swift
//  integralerpapp
//
//  Created by Eyal Muchtar on 20/11/2016.
//  Copyright © 2016 Integral. All rights reserved.
//

import Foundation
import CoreData

@available(iOS 10.0, *)
class CoreDataManager {
    
    // Adding Core data Continer to existing project
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "IntegralErpData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
