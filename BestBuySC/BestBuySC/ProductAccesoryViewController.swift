//
//  ProductAccesoryViewController.swift
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

class ProductAccesoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    //MARK: - IBOutlets
    @IBOutlet weak var productCollectionView: UICollectionView!

    //MARK: - Member variables
    var accessoryProductList: [BestBuyProduct]! {
        didSet {
            updateAccessoryList()
        }
    }
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    //MARK: - CollectionView delegates
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath) as! ProductCollectionViewCell
        if let accessories = self.accessoryProductList {
            if indexPath.row < accessories.count {
                let item = accessories[indexPath.row] as BestBuyProduct
                let imageURL = NSURL(string: item.thumbnailImageURL)
                cell.imageView.hnk_setImageFromURL(imageURL!)
                cell.textLabel.text = item.name
            }
        }
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.accessoryProductList?.count ?? 0
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    //MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            accessoryProductList = productItem.accessoryProducts
        }
    }

    func getAccessoryProducts() {
        if let productItem = self.productItem as? BestBuyProduct {
            // Clear accessoryProductList.
            accessoryProductList = [BestBuyProduct]()
            productItem.accessoryProducts = accessoryProductList

            // Create an activity/progress-view.
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.labelText = "Fetching related products ..."
            progressHUD.mode = MBProgressHUDMode.Determinate
            progressHUD.progress = 0.0
            let nrAccessories = productItem.skuAccessories.count
            let progressStep = (nrAccessories == 0 ? 1.0 : 1.0 / Float(nrAccessories))

            // Get reference to session and perform appropriate sku-queries.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
                let session = productItem.session
                for skuAccessoryProduct in productItem.skuAccessories {
                    let skuRequest = session.getSKUQuery(skuAccessoryProduct["sku"].intValue)
                    Alamofire.request(.GET, skuRequest)
                        .responseJSON { (req, res, json, error) in
                            if error != nil {
                                self.log.error("AFrequest='\(req)', response='\(res)', failed with error='\(error)'")
                                let errDetail = res?.allHeaderFields
                                let errCode = res?.statusCode
                                let aTitle = "Oops, something went wrong!"
                                let aMesg = "\(errDetail)"
                                let alert: UIAlertController = UIAlertController(title: aTitle, message: aMesg, preferredStyle: UIAlertControllerStyle.Alert)
                                let actionOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                                alert.addAction(actionOK)
                                self.presentViewController(alert, animated: true, completion: nil)
                                dispatch_async(dispatch_get_main_queue()) {
                                    progressHUD.progress += progressStep
                                }
                            } else {
                                let json = JSON(json!)
                                let bbProduct = BestBuyProduct(json: json.dictionaryValue, session: session)
                                self.accessoryProductList.append(bbProduct)
                                productItem.accessoryProducts = self.accessoryProductList
                                // Note: need to add update-call since last accessoryProductList.didSet doesn't do it!??
                                self.updateAccessoryList()
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

    func updateAccessoryList() {
        if let accessoryCollection = productCollectionView, let accessories = accessoryProductList {
            accessoryCollection.reloadData()
            self.title = "Accessories (" + String(accessories.count) + ")"
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateAccessoryList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        productCollectionView.backgroundColor = UIColor.whiteColor()
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.registerClass(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        getAccessoryProducts()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
