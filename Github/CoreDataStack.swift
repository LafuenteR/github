//
//  CoreDataStack.swift
//  Github
//
//  Created by Ruel Lafuente on 10/6/21.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Github")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        print("coreDataURL",persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)
        mainContext = persistentContainer.viewContext
    }
}
