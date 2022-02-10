//
//  ScrollableController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/16/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class ScrollableController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: view.frame)
        
        return sv
    }()
}
