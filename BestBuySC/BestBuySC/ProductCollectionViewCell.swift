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
            if !imageName.isEmpty {
                if let image = UIImage(named: imageName) {
                    imageView.image = image
                }
//            } else {
//                imageView.image = nil
            }
        }
        willSet {
            log.debug("willSet: imageName='\(imageName)' newValue='\(newValue)'")
        }
    }
    var imageView: UIImageView = UIImageView()
    var textLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        log.debug("frame=\(frame)")
        super.init(frame: frame)

        let imageFrame = CGRect(x: 10.0, y: 0.0, width: 50.0, height: 50.0)
        imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)

        let textFrame = CGRect(x: 0, y: 32, width: frame.size.width, height: frame.size.height/3)
        textLabel = UILabel(frame: textFrame)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }

}