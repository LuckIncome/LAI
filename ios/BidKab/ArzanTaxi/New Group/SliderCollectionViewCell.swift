//
//  SliderCollectionViewCell.swift
//  BidKab
//
//  Created by Eldor Makkambayev on 8/30/19.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import Foundation
import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    private func setupViews() -> Void {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-30)
            make.right.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(-40)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
