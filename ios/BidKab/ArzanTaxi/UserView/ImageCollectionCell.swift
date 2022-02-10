//
//  ImageCollectionCell.swift
//  ArzanTaxi
//
//  Created by MAC on 11.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class ImageCollectionCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "nav_bar_plus")
        i.layer.borderColor = UIColor.blue.cgColor
        i.layer.borderWidth = 1.0
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    let orderImage: UIImageView = {
        let i = UIImageView()
        i.image = UIImage()
        i.layer.borderColor = UIColor.blue.cgColor
        i.layer.borderWidth = 1.0
        i.contentMode = .scaleAspectFill
        return i
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        addSubview(orderImage)
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        backgroundColor = .blue

        image.snp.makeConstraints { (make) in
            make.left.top.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        orderImage.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
