//
//  CoreDataManager.swift
//  MobiquityWeatherAssignment
//
//  Created by Shafiullah, Mohammed (Cognizant) on .
//

import UIKit
import CoreData
struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MobiquityWeatherAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    @discardableResult
    func savePlace(location: SelectedPlace) -> Place? {
        let context = persistentContainer.viewContext
        
        let entity =
            NSEntityDescription.entity(forEntityName: "Place",
                                       in: context)!
        
        let place = NSManagedObject(entity: entity,
                                     insertInto: context) as! Place
        place.name = location.name
        place.lat =  location.latitude
        place.lng = location.longitude
        
        do {
            try context.save()
            return place
        } catch {
            
        }
        return nil
    }
    
    func getPlaces() -> [Place]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        do {
            let details = try context.fetch(fetchRequest)
            return details
        } catch {
            
        }
        return nil
    }
    
    func deletePlace(place: Place) {
        let context = persistentContainer.viewContext
        context.delete(place)
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func deleteAllPlaces() {
        let context = persistentContainer.viewContext
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: req)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

