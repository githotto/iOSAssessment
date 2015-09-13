//
//  RelatedProductsTableViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm
import Alamofire
import SwiftyJSON
import MBProgressHUD

class RelatedProductListTableViewController: UITableViewController {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - IBOutlets
    @IBOutlet var relatedProductsTable: UITableView!

    // MARK: - Member variables
    var relatedProductList: [BestBuyProduct]! {
        didSet {
            updateRelatedProductList()
        }
    }
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.productItem as? BestBuyProduct)?.relatedProducts.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProductInfoCell", forIndexPath: indexPath) as! ProductInfoCell
        if let products = self.relatedProductList {
            if indexPath.row < products.count {
                let item = products[indexPath.row] as BestBuyProduct
                let imageURL = NSURL(string: item.thumbnailImageURL)
                cell.productImageView.hnk_setImageFromURL(imageURL!)
                cell.productName!.text = item.name
                cell.productPrice!.text = "\(item.regularPrice)"
            }
        }
        return cell
    }

    func updateRelatedProductList() {
        if let table = relatedProductsTable, let relatedProducts = relatedProductList {
            table.reloadData()
            self.title = "Related (" + String(relatedProducts.count) + ")"
        }
    }

    // MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            relatedProductList = productItem.relatedProducts
        }
    }

    func getRelatedProducts() {
        if let productItem = self.productItem as? BestBuyProduct {
            // Clear relatedProductObjects.
            relatedProductList = [BestBuyProduct]()
            productItem.relatedProducts = relatedProductList

            // Create an activity/progress-view.
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.labelText = "Fetching related products ..."
            progressHUD.mode = MBProgressHUDMode.DeterminateHorizontalBar
            progressHUD.progress = 0.0
            let nrRelatedProducts = productItem.skuRelatedProducts.count
            let progressStep = (nrRelatedProducts == 0 ? 1.0 : 1.0 / Float(nrRelatedProducts))

            // Get reference to session and perform appropriate sku-queries.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                let session = productItem.session
                for skuRelatedProduct in productItem.skuRelatedProducts {
                    let skuRequest = session.getSKUQuery(skuRelatedProduct["sku"].intValue)
                    Alamofire.request(.GET, skuRequest)
                        .responseJSON { (req, res, json, error) in
                            if error != nil {
                                self.log.error("AFrequest='\(req)', response='\(res)', failed with error='\(error)'")
                                let errDetail = res?.allHeaderFields
                                let errCode = res?.statusCode
                                let title = "Oops, something went wrong!"
                                let message = "\(errDetail)"
                                let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                                let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                alert.addAction(actionOK)
                                self.presentViewController(alert, animated: true, completion: nil)
                                dispatch_async(dispatch_get_main_queue()) {
                                    progressHUD.progress += progressStep
                                }
                            } else {
                                let json = JSON(json!)
                                let bbProduct = BestBuyProduct(json: json.dictionaryValue, session: session)
                                self.relatedProductList.append(bbProduct)
                                productItem.relatedProducts = self.relatedProductList
                                // Note: need to add update-call since last relatedProductList.didSet doesn't do it!??
                                self.updateRelatedProductList()
                                dispatch_async(dispatch_get_main_queue()) {
                                    progressHUD.progress += progressStep
                                }
                            }
                    }
                    // Note: If we get the error "Account Over Queries Per Second Limit"
                    //       we need to add a delay between consecutive calls here.
                    var delayQueriesPerSecondLimit: NSTimeInterval = 0.21
                    NSThread.sleepForTimeInterval(delayQueriesPerSecondLimit)
                }
                dispatch_async(dispatch_get_main_queue()) {
                    progressHUD.hide(true)
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateRelatedProductList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        getRelatedProducts()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
