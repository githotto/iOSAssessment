//
//  SearchViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class SearchViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - Member variable(s).
    var currentSession = BestBuySession()

    // MARK: - IBActions
    @IBAction func changeSearchName(sender: AnyObject) {
        if let searchText = sender as? UITextField {
            currentSession.searchTerm = searchText.text
            println("SearchText=\(searchText.text)")
        }
    }

    @IBAction func doSearch(sender: AnyObject) {
        log.warning("TODO: should perform search to get appropriate results...")
    }

    // MARK: - Textfield Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - View lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Mark: - Memory management.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowProducts" {
            if let dest = segue.destinationViewController as? ProductListTableViewController {
                dest.sessionItem = currentSession
            }
        }
    }
}
