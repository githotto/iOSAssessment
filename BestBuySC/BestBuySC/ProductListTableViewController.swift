//
//  ProductListTableViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class ProductListTableViewController: UITableViewController {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - IBOutlets
    @IBOutlet var productTable: UITableView!

    // MARK: - Member variables
    var productInfoObjects: [BestBuyProduct]!
    var sessionItem: AnyObject? {
        didSet {
            // Update the view.
            log.warning("")
            self.configureView()
        }
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowProductDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = productInfoObjects[indexPath.row] as BestBuyProduct
                (segue.destinationViewController as! ProductDetailViewController).productItem = object
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sessionItem = self.sessionItem as? BestBuySession {
            return sessionItem.searchResults.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductInfoCell", forIndexPath: indexPath) as! ProductInfoCell
        if let products = self.productInfoObjects {
            let item = products[indexPath.row] as BestBuyProduct
            if let imageData = UIImage(named: item.imageName) {
                cell.productImageView.image = imageData
            }
            cell.productName!.text = item.productName
            cell.productPrice!.text = "\(item.price)"
        }
        return cell
    }

    func updateItemList() {
        productTable.reloadData()
        if let products = productInfoObjects {
            self.title = "Items (" + String(products.count) + ")"
        }
    }

    // MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let sessionItem = self.sessionItem as? BestBuySession {
            log.error("TODO")
            log.warning("sessionItem=\(sessionItem)")
            productInfoObjects = sessionItem.searchResults
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateItemList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
