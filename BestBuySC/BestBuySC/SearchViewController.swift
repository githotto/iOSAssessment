//
//  SearchViewController.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm
import Alamofire

class SearchViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    // MARK: - Member variable(s).
    var currentSession = BestBuySession()

    // MARK: - IBActions
    @IBAction func changeSearchName(sender: AnyObject) {
        if let searchText = sender as? UITextField {
            currentSession.searchTerm = searchText.text
            println("SearchText=\(searchText.text)")
        }
    }

    @IBAction func doSearch(sender: AnyObject) {
        log.warning("TODO ...")

        // Note: below variables relate to BB-account
        let appName = "BestBuySC"
        let bbKey = "&apiKey=m5ykepuxrkwg94z2mwyqjv2p"
        let reqParams = ["apiKey": "m5ykepuxrkwg94z2mwyqjv2p"]

        let prodName = "iPhone*"
        let bbReq = "http://api.bestbuy.com/v1/products(longDescription=" + prodName + ")?show=name&format=json"

        // Note1: BB-API example below works!
        let req = "http://api.bestbuy.com/v1/products/8880044.json?apiKey=m5ykepuxrkwg94z2mwyqjv2p"

        // Note2: Use e.g. http://bestbuyapis.github.io/bby-query-builder/#/productSearch to compose queries!
        // let req = "https://api.bestbuy.com/v1/products(search=iPhone)?apiKey=m5ykepuxrkwg94z2mwyqjv2p&format=json"

        // Note3: This query (build by above URL) doesn't work, and give parse errors!?
//        let req = "https://api.bestbuy.com/v1/products((search=iPhone)&)?apiKey=m5ykepuxrkwg94z2mwyqjv2p&sort=image.asc&show=image,name,regularPrice,shipping,customerReviewCount,customerReviewAverage,description,relatedProducts.sku,accessories.sku&callback=JSON_CALLBACK&format=json"

        // TODO: What is the best way to get a 'working' query/response?
//        // fatal error: unexpectedly found nil while unwrapping an Optional value
//        Alamofire.request(.GET, req, parameters: ["apiKey": "m5ykepuxrkwg94z2mwyqjv2p"])
//            .response {
//                request, response, data, error in
//                println("request=\(request)")
//                println("response=\(response)")
//                println("error=\(error)")
//        }

        Alamofire.request(.GET, req)
            .responseJSON { _, _, JSON, _ in
                log.debug("responseJSON=\(JSON)")
            }
            .responseString { _, _, string, _ in
                log.debug("responseString=\(string)")
            }
    }

    // MARK: - Textfield Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - View lifecycle.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Mark: - Memory management.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueShowProducts" {
            if let dest = segue.destinationViewController as? ProductListTableViewController {
                dest.sessionItem = currentSession
            }
        }
    }
}
