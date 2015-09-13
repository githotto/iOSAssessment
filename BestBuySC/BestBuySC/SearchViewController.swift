//
//  SearchViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var searchTextField: UITextField!

    // MARK: - Member variable(s).
    var currentSession = BestBuySession()

    // MARK: - IBActions
    @IBAction func changeSearchName(sender: AnyObject) {
        if let searchText = sender as? UITextField {
            currentSession.searchTerm = searchText.text
        }
    }

    @IBAction func doSearch(sender: AnyObject) {
        self.currentSession.searchTerm = self.searchTextField.text
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowProducts" {
            if let dest = segue.destinationViewController as? ProductListTableViewController {
                dest.sessionItem = currentSession
            }
        }
    }

    // MARK: - Textfield Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - View lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Mark: - Memory management.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
