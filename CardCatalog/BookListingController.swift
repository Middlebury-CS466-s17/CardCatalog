//
//  BookListingController.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/4/17.
//  Copyright © 2017 Christopher Andrews. All rights reserved.
//

import UIKit
import CoreData

class BookListingController: UITableViewController, NSFetchedResultsControllerDelegate {

    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    private let books = BookCollection(){
        print("Core Data connected")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add the edit button on the left side programmatically
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        initializeFetchResultsController()
    }

    
    /*
     Initialize the fetched results controller
     
     We configure this to fetch all of the books and break them into sections based on author name.
     */
    func initializeFetchResultsController(){
        // get all books
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Book")
        
        // sort by author anme and then by title
        let authorSort = NSSortDescriptor(key: "author.name", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [authorSort, titleSort]
        
        // Create the controller using our moc
        let moc = books.managedObjectContext
        fetchedResultsController  = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: "author.name", cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Failed to fetch data")
        }
        
    }
    
    
    

    // MARK: - Table view data source functions

    /* Report the number of sections (managed by fetched results controller) */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }

    /* Report the number of rows in a particular section (managed by fetched results controller) */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController!.sections else{
            fatalError("No sections found")
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }

    /* Get a table cell loaded with the right data for the entry at indexPath (section/row)*/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get one of our custom cells, building or reusing as needed
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookListingCell", for: indexPath) as? BookListingCell else{
            fatalError("Can't get cell of the right kind")
        }
        
        guard let book = self.fetchedResultsController.object(at: indexPath) as? Book else{
            fatalError("Cannot find book")
        }

        cell.configureCell(book: book)
        
        return cell
    }
 
    /* Get the title to be displayed between sections */
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController.sections else{
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.name
    }

    
    /* Provides the edit functionality (deleteing rows) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            guard let book = self.fetchedResultsController?.object(at: indexPath) as? Book else{
                fatalError("Cannot find book")
            }
            
            books.delete(book)
        }
    }
    

    // MARK: Connect tableview to fetched results controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
  
    // MARK: - Navigation
    
    // prepare to go to the detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        switch(segue.identifier ?? ""){
        case "AddBook":
            guard let navController = segue.destination as? UINavigationController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let destination = navController.topViewController as? BookDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            destination.type = .new
            destination.callback = { (title, authorName, year) in
                self.books.add(title:title, authorName: authorName, year: year)
            }
        case "EditBook":
            
            guard let destination = segue.destination as? BookDetailViewController else{
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let cell = sender as? BookListingCell else{
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else{
                fatalError("The selected cell can't be found")
            }
            
            
            guard let book = fetchedResultsController?.object(at: indexPath) as? Book else{
                fatalError("fetched object was not a Book")
            }
            
            destination.type = .update(book.title!, book.author!.name!, book.year)
            destination.callback = { (title, author, year) in
                self.books.update(oldBook: book, title: title, authorName: author, year: year)
            }
            
            
        default:
            fatalError("Unexpeced segue identifier: \(segue.identifier)")
        }
        
    }
    
    /* This is here so that we have something to return to. It doesn't actually provide much functionality since the tableView is already tied to the fetched results controller. */
    @IBAction func unwindFromEdit(sender: UIStoryboardSegue){
        tableView.reloadData()
    }


}
