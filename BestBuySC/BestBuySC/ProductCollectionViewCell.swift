//
//  ProductCollectionViewCell.swift
//  BestBuySC
//
//  Created by Otto van Verseveld on 09/09/15.
//  Copyright (c) 2015 Otto van Verseveld. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    // MARK: - Member variables
    var imageView: UIImageView = UIImageView()
    var textLabel: UILabel = UILabel()


    // MARK: - Intiliazer(s)
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imageFrame = CGRect(x: 10.0, y: 0.0, width: 100.0, height: 100.0)
        imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)

        let textFrame = CGRect(x: 0, y: 100, width: frame.size.width, height: 28)
        textLabel = UILabel(frame: textFrame)

        //TODO: minScaleFactor doesn't work yet!? So instead use code below:
//        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        textLabel.minimumScaleFactor = 0.5
        textLabel.font = UIFont.systemFontOfSize(9.0)

        textLabel.textAlignment = .Center
        contentView.addSubview(textLabel)
    }

}