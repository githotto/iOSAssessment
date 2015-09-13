//
//  ProductListTableViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm
import Alamofire
import SwiftyJSON
import Haneke
import MBProgressHUD

class ProductListTableViewController: UITableViewController {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - IBOutlets
    @IBOutlet var productTable: UITableView!

    // MARK: - Member variables
    var productList: [BestBuyProduct]! {
        didSet {
            updateProductList()
        }
    }
    var sessionItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowProductDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = productList[indexPath.row] as BestBuyProduct
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
        if let products = self.productList {
            if indexPath.row < products.count {
                let item = products[indexPath.row] as BestBuyProduct
                let imageURL = NSURL(string: item.thumbnailImageURL)
                cell.productImageView.hnk_setImageFromURL(imageURL!)
                log.debug("cell[\(indexPath.row)].imageSize=\(cell.productImageView.image?.size)")
                cell.productName!.text = item.name
                cell.productRelatedAndAccesories.text = item.getSKUinfo()
                cell.productPrice!.text = "\(item.regularPrice)"
            }
        }
        return cell
    }

    // MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let sessionItem = self.sessionItem as? BestBuySession {
            productList = sessionItem.searchResults
        }
    }

    func getProducts() {
        log.debug("")
        if let session = self.sessionItem as? BestBuySession {
            // Reset producList.
            productList = [BestBuyProduct]()
            session.searchResults = productList
            // Create an activity/progress-view.
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.labelText = "Fetching products ..."
            progressHUD.mode = MBProgressHUDMode.Indeterminate

            // Note: Since Alamofire works in async, we do NOT need to add an
            //       dispatch_async(dispatch_get_main_queue()){..} here for progressHUD.
            // Perform request.
            Alamofire.request(.GET, session.searchRequest)
                .responseJSON { (req, res, json, error) in
                    if error != nil {
                        self.log.error("AFrequest='\(req)', response='\(res)', failed with error='\(error)'")
                        progressHUD.hide(true)
                    } else {
                        let json = JSON(json!)
                        let products = json["products"]
                        for index in 0..<products.count {
                            let product = products[index].dictionaryValue
                            let bbProduct = BestBuyProduct(json: product, session: session)
                            self.productList.append(bbProduct)
                        }
                        session.searchResults = self.productList
                        //Note: need to add below update-call since last productList.didSet doesn't do it!??
                        self.updateProductList()
                        progressHUD.hide(true)
                    }
                }
                // Note: If you want to save the response uncomment code below!
//                .responseString { (_, _, string, _) in
//                    session.saveResponse(string!, path: session.searchResponsePath)
//                    progressHUD.hide(true)
//                }
        }
    }

    func updateProductList() {
        if let table = productTable, let products = productList {
            table.reloadData()
            self.title = "Products (" + String(products.count) + ")"
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateProductList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getProducts()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
