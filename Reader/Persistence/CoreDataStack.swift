//
//  CoreDataStack.swift
//  Reader
//
//  Created by Mallikharjuna on 17/08/25.
//

import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    private init(){}
    lazy var container:NSPersistentContainer = {
        let persistReader = NSPersistentContainer(name: "Reader")
        persistReader.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData error: \(error)")
                
            }
        }
        persistReader.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        persistReader.viewContext.automaticallyMergesChangesFromParent = true
      return persistReader
    }()
    var context:NSManagedObjectContext {
        container.viewContext
    }
    func save(){
        guard context.hasChanges else {
            return
        }
        do {
            try context.save()
            
        } catch {
            print("CoreData save error: \(error)")
            
        }
    }
}
