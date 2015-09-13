//
//  BestBuySession.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import Foundation
import Loggerithm
import Alamofire
import SwiftyJSON

class BestBuySession {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - Member variables.
    var searchRequest = ""
    private var searchRequestFormat = "https://api.bestbuy.com/v1/products(search=%@)?apiKey=m5ykepuxrkwg94z2mwyqjv2p&format=json"
    var searchResponsePath = ""
    var searchTerm: String = "" {
        didSet {
            self.searchRequest = NSString(format: searchRequestFormat, searchTerm) as String
        }
    }
    var searchResults = [BestBuyProduct]()

    // MARK: - Initialization.
    init() {
        // Determine path where response is saved.
        let searchResultFile = "SearchResult.json"
        if let dirs: [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as? [String] {
            let docDir = dirs[0]
            searchResponsePath = docDir.stringByAppendingPathComponent(searchResultFile)
        } else {
            log.error("Cannot determine dirs for categoryResponsePath and searchResponsePath!")
        }
    }

    // MARK: - Get appropriate SKU-query.
    func getSKUQuery(skuNr: Int) -> String {
        let skuQueryFormat = "http://api.bestbuy.com/v1/products/%d.json?apiKey=m5ykepuxrkwg94z2mwyqjv2p"
        return String(format: skuQueryFormat, skuNr)
    }

    // MARK: - Read/save JSON-response results (debugging only).
    func readResponse() -> String {
        return String(contentsOfFile: searchResponsePath, encoding: NSUTF8StringEncoding, error: nil)!
    }

    func saveResponse(response: String, path: String) {
        response.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    }
}