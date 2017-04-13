//
//  BookCollection.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/3/17.
//  Copyright © 2017 Andrews, Christopher P. All rights reserved.
//

import Foundation


class BookCollection{
    
    var collection = [Book]()
    
    init(){
        collection += [
            Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", year: 1979),
            Book(title: "The Moon is a Harsh Mistress", author: "Robert Heinlein", year: 1966),
            Book(title: "Desolation Road", author: "Ian McDonald", year: 1988)
        ]
    }
    
    
    func add(title:String, author:String, year: Int16){
        collection.append(Book(title: title, author: author, year: year))
    }
    
    func remove(at index:Int){
        collection.remove(at: index)
    }

}
