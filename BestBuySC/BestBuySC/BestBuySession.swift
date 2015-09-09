//
//  BestBuySession.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import Foundation

class BestBuySession {

    var searchTerm = "Enter your productname here"
    var searchResults = [BestBuyProduct]()

    init() {
        //Note: for testing only!
        mockInit()
    }

    func mockInit() {
        searchResults.append(BestBuyProduct(imageName: "bloes", productName: "Bloes", price: 1.0))
        searchResults.append(BestBuyProduct(imageName: "broek", productName: "Broek", price: 2.0))
        searchResults.append(BestBuyProduct(imageName: "hemd", productName: "Hemd", price: 3.0))
        searchResults.append(BestBuyProduct(imageName: "hoed", productName: "Hoed", price: 4.0))
        searchResults.append(BestBuyProduct(imageName: "jurk", productName: "Jurk", price: 5.0))
        searchResults.append(BestBuyProduct(imageName: "laars", productName: "Laars", price: 6.0))
        // Add related products for first item only!
        searchResults[0].relatedProducts.append(BestBuyProduct(imageName: "pet", productName: "Pet", price: 1.1))
        searchResults[0].relatedProducts.append(BestBuyProduct(imageName: "trui", productName: "Trui", price: 1.2))
        searchResults[0].relatedProducts.append(BestBuyProduct(imageName: "broek", productName: "Broek", price: 1.3))
        searchResults[0].relatedProducts.append(BestBuyProduct(imageName: "sandaal", productName: "Sandaal", price: 1.4))
        // Add accessory items for first item only!
        searchResults[0].accessoryProducts.append(BestBuyProduct(imageName: "hemd", productName: "Hemd", price: 2.1))
        searchResults[0].accessoryProducts.append(BestBuyProduct(imageName: "hoed", productName: "Hoed", price: 2.2))
    }
}