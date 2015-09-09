//
//  ProductCollectionViewCell.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit
import Loggerithm

class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Logger
    var log = Loggerithm.newLogger(LogLevel.Warning)

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var imageName: String = "" {
        didSet {
            log.debug("didSet: imageName='\(imageName)' oldValue='\(oldValue)'")
            if imageName != "" {
                if let image = UIImage(named: imageName) {
                    imageView.image = image
                }
            } else {
                imageView.image = nil
            }
        }
        willSet {
            log.warning("willSet: imageName='\(imageName)' newValue='\(newValue)'")
        }
    }
    var imageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        log.debug("frame=\(frame)")
        super.init(frame: frame)
        let realFrame = CGRect(x: 10.0, y: 0.0, width: 50.0, height: 50.0)
        imageView = UIImageView(frame: realFrame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
    }
    
}