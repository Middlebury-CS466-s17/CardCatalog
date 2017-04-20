//
//  BookCollection.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/3/17.
//  Copyright © 2017 Andrews, Christopher P. All rights reserved.
//

import Foundation
import CoreData

class BookCollection{
    
    var managedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer
    
    
    
    init(completionClosure: @escaping ()->()){
        persistentContainer = NSPersistentContainer(name:"CardCatalog")
        managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores(){ (description, err) in
            if let err = err{
                fatalError("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
        
        
        
//        collection += [
//            Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", year: 1979),
//            Book(title: "The Moon is a Harsh Mistress", author: "Robert Heinlein", year: 1966),
//            Book(title: "Desolation Road", author: "Ian McDonald", year: 1988)
//        ]
    }
    
    
    func add(title:String, author:String, year: Int16){
        var book:Book!
        managedObjectContext.performAndWait {
            book = Book(context: self.managedObjectContext)
            book.title = title
            book.author = author
            book.year = year
        }
        
       // collection.append(Book(title: title, author: author, year: year))
    }
    
//    func remove(at index:Int){
//        //collection.remove(at: index)
//        
//    }
    
    func delete(_ book: Book){
        managedObjectContext.delete(book)
    }
    
    func saveChanges () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
