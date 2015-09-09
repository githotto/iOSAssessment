//
//  ProductDetailViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class ProductDetailViewController: UIViewController {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - IBOutlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var nrReviews: UILabel!
    @IBOutlet weak var reviewAverage: UILabel!
    @IBOutlet weak var remark: UILabel!

    // MARK: - ViewController variables
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowRelatedProducts" {
            (segue.destinationViewController as! RelatedProductsTableViewController).productItem = productItem
        }
    }

    // MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            log.error("TODO")
            if let image = self.image {
                image.image = UIImage(named: productItem.imageName)
            }
            if let name = self.name {
                name.text = "Name: " + productItem.productName
            }
            if let price = self.price {
                price.text = "Price: \(productItem.price)"
            }
            if let salePrice = self.salePrice {
                salePrice.text = "Saleprice: \(productItem.salePrice)"
            }
            if let nrReviews = self.nrReviews {
                nrReviews.text = "Number of reviews: \(productItem.nrReviews)"
            }
            if let reviewAverage = self.reviewAverage {
                reviewAverage.text = "Review average: \(productItem.reviewAverage)"
            }
            if let remark = self.remark {
                remark.text = "Description: " + productItem.remark
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        configureView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
