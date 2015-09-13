//
//  BestBuyProduct.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import SwiftyJSON

class BestBuyProduct {
    // Internal (model) relationships:
    var relatedProducts = [BestBuyProduct]()
    var accessoryProducts = [BestBuyProduct]()
    var session: BestBuySession         // Note: referred to from getXX-queries.

    // BestBuy ProductAttributeList members:
    // See: https://developer.bestbuy.com/documentation/products-api#ProductDetailExample4
    var customerReviewAverage = 0.0
    var customerReviewCount = 0
    var imageURL = ""
    var name = ""
    var onSale = true
    var regularPrice = 0.0
    var salePrice = 0.0
    var shortDescription = ""
    var sku = 0
    var thumbnailImageURL = ""
    // References to other BBproducts:
    var skuAccessories = [JSON]()       // sku.Array to be filled in VCAccessories.
    var skuRelatedProducts = [JSON]()   // sku.Array to be filled in VCRelatedProducts.

    // MARK: - Initializer(s)
    init(json: Dictionary<String, JSON>, session: BestBuySession) {
        self.session = session
        // Get appropriate BBproduct attributes:
        sku = json["sku"]?.int ?? 0
        name = json["name"]?.string ?? "Unknown"
        regularPrice = json["regularPrice"]?.double ?? 0.0
        onSale = json["onSale"]?.bool ?? false
        salePrice = json["salePrice"]?.double ?? 0.0
        customerReviewCount = json["customerReviewCount"]?.int ?? 0
        customerReviewAverage = json["customerReviewAverage"]?.double ?? 0.0
        shortDescription = json["shortDescription"]?.string ?? ""

        // Get BestBuy Product image-attribute members:
        // See: https://developer.bestbuy.com/documentation/products-api#documentation/products-api-images
        imageURL = json["image"]?.string ?? ""
        thumbnailImageURL = json["thumbnailImage"]?.string ?? ""

        // Get other BBproduct references:
        skuAccessories = json["accessories"]?.array ?? [JSON]()
        skuRelatedProducts = json["relatedProducts"]?.array ?? [JSON]()
    }

    // MARK: - Related info
    func getSKUinfo() -> String {
        var info = ""
        let nrRelated = skuRelatedProducts.count
        let nrAccessories = skuAccessories.count
        if nrRelated > 0 {
            info = "#Related: \(nrRelated) "
        }
        if nrAccessories > 0 {
            info += "#Accessories: \(nrAccessories)"
        }
        return info
    }
}