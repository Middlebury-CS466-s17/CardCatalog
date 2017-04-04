//
//  BookCollection.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/3/17.
//  Copyright © 2017 Andrews, Christopher P. All rights reserved.
//

import Foundation


class BookCollection{
    
    var collection = [BookListing]()
    
    init(){
        collection += [
            BookListing(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", year: 1979),
            BookListing(title: "The Moon is a Harsh Mistress", author: "Robert Heinlein", year: 1966),
            BookListing(title: "Desolation Road", author: "Ian MacDonald", year: 1988)
        ]
    }
    
}
