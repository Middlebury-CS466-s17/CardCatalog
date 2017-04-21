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
    
    var managedObjectContext: NSManagedObjectContext // our in-memory data store and portal to the database
    var persistentContainer: NSPersistentContainer // our database connection
    
    
    /* Initializes our collection by connecting to the database.
 
     The closure is called when the connection has been established.
     */
    init(completionClosure: @escaping ()->()){
        persistentContainer = NSPersistentContainer(name:"CardCatalog")
        managedObjectContext = persistentContainer.viewContext
        
        persistentContainer.loadPersistentStores(){ (description, err) in
            if let err = err{
                // should try harder to mkae the connection and not just dump the user
                fatalError("Could not load Core Data: \(err)")
            }
            
            completionClosure()
        }
    }
    
    /*
     This function will return an Author, creating if it doesn't exist.
     
     it is following the find-or-create design pattern
     */
    private func findAuthor(name:String)->Author?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Author")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format:"name == %@", name)
        do {
            let matches = try managedObjectContext.fetch(request)
            
            if (matches.count == 0){
                // can't find the author, make one
                var author:Author!
                managedObjectContext.performAndWait {
                    author = Author(context: self.managedObjectContext)
                    author.name = name
                }
                return author
            }else{
                return matches[0] as? Author
            }
        }catch{
            fatalError("Unable to fetch authors")
        }
        return nil
    }

    /* Add a new book to the collection */
    func add(title:String, authorName:String, year: Int16){
        let author = findAuthor(name: authorName)
        var book:Book!
        managedObjectContext.performAndWait {
            book = Book(context: self.managedObjectContext)
            book.title = title
            book.author = author
            book.year = Int16(year)
            self.saveChanges()
        }
    }
    
    /* Update the fields on a book 
     
     We make this a seperate function rather than setting the values directly so that we can use findAuthor and save changes.
     */
    func update(oldBook: Book, title:String, authorName: String, year: Int16){
        if oldBook.author?.name != authorName {
            // we can't just adjust the name because of various data dependancies
            // so we will delete the book and make a new one
            delete(oldBook)
            add(title: title, authorName: authorName, year: year)
        }else{
            oldBook.title = title
            oldBook.year = Int16(year)
        }
        self.saveChanges()
    }
    
    /*
     Remove a book from the collection
     */
    func delete(_ book: Book){
        managedObjectContext.delete(book)
        self.saveChanges()
    }
    
    
    /*
     Save any changes stored in our moc back to the database.
     */
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
