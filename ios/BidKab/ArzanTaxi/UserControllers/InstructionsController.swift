//
//  InstructionsController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/16/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class InstructionsController: ScrollableController {
    
    let images: [UIImage]

    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let width: CGFloat = view.frame.width
        let height: CGFloat = width * 0.75
        scrollView.contentSize = CGSize(width: width, height: CGFloat(images.count) * height)
        for i in 0..<images.count {
            let imageView = UIImageView(image: images[i])
            scrollView.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: height * CGFloat(i), width: width, height: height)
        }
    }
}
