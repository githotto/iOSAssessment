//
//  BestBuyProduct.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import Foundation

class BestBuyProduct {

    var image = NSData()
    var imageName = ""
    var productName = ""
    var price = 0.0
    var salePrice = 0.0
    var nrReviews = 0
    var reviewAverage = 1.0
    var remark = ""
    var relatedProducts = [BestBuyProduct]()
    var accessoryProducts = [BestBuyProduct]()

    init(imageName: String, productName: String, price: Double) {
        self.imageName = imageName
        self.productName = productName
        self.price = price
    }
    
}