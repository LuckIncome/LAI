//
//  RefreshControlCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/24/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class RefresherCell: UICollectionViewCell {
    
    lazy var refresher: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        return rc
    }()
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        
    }
}
