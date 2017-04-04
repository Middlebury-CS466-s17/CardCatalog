//
//  BookListingCell.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/4/17.
//  Copyright © 2017 Christopher Andrews. All rights reserved.
//

import UIKit

class BookListingCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    
    func configureCell(book: BookListing){
        titleLabel.text = book.title
        authorLabel.text = book.author
        yearLabel.text = String(book.year)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
