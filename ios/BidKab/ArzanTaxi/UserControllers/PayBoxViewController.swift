//
//  PayBoxViewController.swift
//  ArzanTaxi
//
//  Created by MAC on 27.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class PayBoxViewController: UIViewController {

    var webView = WKWebView()
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pay"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "close"), style: .done, target: self, action: #selector(closeAction))
        setupLayout()
        
        let url = URL(string: self.url)
        let requestObj = URLRequest(url: url!)
        webView.load(requestObj)
    }
    
    func setupLayout() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    @objc private func closeAction() {
        dismiss(animated: true, completion: nil)
    }
}
