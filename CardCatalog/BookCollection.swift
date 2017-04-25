//
//  BookCollection.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/3/17.
//  Copyright © 2017 Andrews, Christopher P. All rights reserved.
//

import Foundation
import CloudKit


protocol BookCollectionDelegate{
    func dataChanged()
}


class BookCollection{
    private let dbPublic: CKDatabase
    
    var delegate:BookCollectionDelegate?
    
    var collection = [Book]()
    
    init(){
        dbPublic = CKContainer.default().publicCloudDatabase
        
        fetchBooks()
        
//        collection += [
//            Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", year: 1979),
//            Book(title: "The Moon is a Harsh Mistress", author: "Robert Heinlein", year: 1966),
//            Book(title: "Desolation Road", author: "Ian McDonald", year: 1988)
//        ]
    }
    
    
    func fetchBooks(){
        let predicate = NSPredicate(value:true)
        let query = CKQuery(recordType: "Books", predicate: predicate)
        
        dbPublic.perform(query, inZoneWith: nil){ (records, err) in
            if (err != nil){
                fatalError("Couldn't connect to iCloud")
            }
            self.collection.removeAll(keepingCapacity: true)
            
            records?.forEach({(record:CKRecord) in
                self.collection.append(Book(record: record, database: self.dbPublic))
            })
            
            if let delegate = self.delegate{
                DispatchQueue.main.async{
                    delegate.dataChanged()
                }
                
            }
            
        }
        
    }
    
    
    func add(title:String, author:String, year: Int16){
        collection.append(Book(title: title, author: author, year: year, database:dbPublic))
        if let delegate = self.delegate{
            delegate.dataChanged()
            
        }
    }
    
    func remove(at index:Int){
        
        let book = collection.remove(at: index)
        book.delete()
    }

}
