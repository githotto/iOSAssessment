//
//  ProductAccesoryViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class ProductAccesoryViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    //MARK: - IBOutlets
    @IBOutlet weak var activityCollectionView: UICollectionView!

    //MARK: - Member variables
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    //MARK: - CollectionView delegates
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath) as! ProductCollectionViewCell
        log.debug("indexPath=\(indexPath)")
//        if let productItem = productItem as? BestBuyProduct {
//
//        }
//        cell.imageName = productItem.acces
        //TODO:
        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: return productItem.accesories.count
        return 0
    }

    //MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            //TODO:
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()

        activityCollectionView.backgroundColor = UIColor.whiteColor()
        activityCollectionView.dataSource = self
        activityCollectionView.delegate = self
        activityCollectionView.registerClass(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
//        activityColors = [String]()
//        updateActivityColorSelection()
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
