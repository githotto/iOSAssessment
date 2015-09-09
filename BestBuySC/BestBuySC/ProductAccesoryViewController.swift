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
    @IBOutlet weak var productCollectionView: UICollectionView!

    //MARK: - Member variables
    var productItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var accessoryProducts: [BestBuyProduct]!

    //MARK: - CollectionView delegates
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductCollectionViewCell", forIndexPath: indexPath) as! ProductCollectionViewCell
        log.debug("indexPath=\(indexPath)")
        cell.imageName = accessoryProducts[indexPath.row].imageName
        return cell
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let accessories = self.accessoryProducts {
            return accessories.count
        } else {
            return 0
        }
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    //MARK: - View lifecycle
    func configureView() {
        // Update the user interface for the detail item.
        if let productItem = self.productItem as? BestBuyProduct {
            accessoryProducts = productItem.accessoryProducts
        }
    }

    func updateItemList() {
        productCollectionView.reloadData()
        if let accessories = accessoryProducts {
            self.title = "Accesories (" + String(accessories.count) + ")"
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateItemList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        productCollectionView.backgroundColor = UIColor.whiteColor()
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        productCollectionView.registerClass(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
        updateItemList()
//        productCollectionView.reloadData()
//        self.title = "Accessories"
    }

    //MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
