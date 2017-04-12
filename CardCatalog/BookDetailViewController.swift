//
//  BookDetailViewController.swift
//  CardCatalog
//
//  Created by Christopher Andrews on 4/6/17.
//  Copyright © 2017 Christopher Andrews. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
