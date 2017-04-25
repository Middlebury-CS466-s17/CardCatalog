//
//  BookListing.swift
//  CardCatalog
//
//  Created by Andrews, Christopher P. on 4/3/17.
//  Copyright © 2017 Andrews, Christopher P. All rights reserved.
//

import Foundation
import CloudKit

class Book{
    private let record:CKRecord
    private let database:CKDatabase
    
    var title:String{
        get{
            return record["title"] as! String
        }
        set(newTitle){
            record["title"] = newTitle as CKRecordValue?
        }
    }
  var author: String
    {
    get{
        return record["author"] as! String
    }
    set(newAuthor){
        record["author"] = newAuthor as CKRecordValue?
    }
    }
    var year:Int16{
        get{
            return record["year"] as! Int16
        }
        set(newYear){
            record["year"] = newYear as CKRecordValue?
        }
    }
  
    
    init(record:CKRecord, database:CKDatabase){
        self.record = record
        self.database = database
    }

    init(title:String, author:String, year: Int16, database:CKDatabase){
        self.record = CKRecord(recordType: "Books")
        self.database = database
        self.title = title
        self.author = author
        self.year = year
        
        save()
  }
  
    
    func save() {
        self.database.save(self.record){(record, err) in
            print("saved")
        }
    }
    
    func delete(){
        self.database.delete(withRecordID: record.recordID){(recordID, err) in
            print("book deleted")
        }
        
    }
  
}
