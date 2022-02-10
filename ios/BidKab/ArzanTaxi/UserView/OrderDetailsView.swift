//
//  OrderDetailsView.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/15/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class OrderDetailsView : UIView {
    
    var aPointLabel = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointa"), text: "")
    var bPointLabel = Helper.createOrderLabel(image: #imageLiteral(resourceName: "pointb"), text: "")
    var priceLabel = Helper.createOrderLabel(image: #imageLiteral(resourceName: "tenge"), text: "")
    
    let underline : UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    func setupView() {        
        addSubview(aPointLabel)
        addSubview(bPointLabel)
        addSubview(priceLabel)
        addSubview(underline)
        
        aPointLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        aPointLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        aPointLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        aPointLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        bPointLabel.topAnchor.constraint(equalTo: aPointLabel.bottomAnchor).isActive = true
        bPointLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bPointLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bPointLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        priceLabel.topAnchor.constraint(equalTo: bPointLabel.bottomAnchor).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        underline.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underline.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        underline.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        underline.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
