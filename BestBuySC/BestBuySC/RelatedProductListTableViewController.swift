//
//  RelatedProductsTableViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class RelatedProductListTableViewController: UITableViewController {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - IBOutlets
    @IBOutlet var relatedProductsTable: UITableView!

    // MARK: - Member variables
    var relatedProductObjects: [BestBuyProduct]!
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            log.debug("")
            self.configureView()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let productItem = self.productItem as? BestBuyProduct {
            return productItem.relatedProducts.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductInfoCell", forIndexPath: indexPath) as! ProductInfoCell
        if let products = self.relatedProductObjects {
            let item = products[indexPath.row] as BestBuyProduct
            log.debug("products[\(indexPath.row)]=\(item.productName)")
            if let imageData = UIImage(named: item.imageName) {
                cell.productImageView.image = imageData
            }
            cell.productName!.text = item.productName
            cell.productPrice!.text = "\(item.price)"
        }
        return cell
    }

    func updateItemList() {
        relatedProductsTable.reloadData()
        if let products = relatedProductObjects {
            self.title = "Related (" + String(products.count) + ")"
        }
    }

    // MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            log.debug("productItem=\(productItem)")
            relatedProductObjects = productItem.relatedProducts
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateItemList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
