//
//  BookDetailViewController.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/6/17.
//  Copyright © 2017 Christopher Andrews. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var type: DetailType = .new
    var callback: ((String, String, Int16)->Void)?
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch(type){
        case .new:
            break
        case let .update(title, author, year):
            navigationItem.title = title
            titleField.text = title
            authorField.text = author
            yearField.text = String(year)
        }
        
    }

   
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController{
            dismiss(animated: true, completion: nil)
        }else if let owningNavController = navigationController{
            owningNavController.popViewController(animated: true)
        }else{
            fatalError("View is not contained by a navigation controller")
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("The save button was not pressed")
            return
        }
        let title = titleField.text ?? ""
        let author = authorField.text ?? ""
        let year = Int16(yearField.text!) ?? 0
        
        if callback != nil{
            callback!(title, author, year)
        }
    }


}


enum DetailType{
    case new
    case update(String, String, Int16)
}
