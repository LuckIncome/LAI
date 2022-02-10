//
//  TutorialCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class TutorialCell : UICollectionViewCell {
    
    var delegate : TutorialViewControllerDelegate?
    
    let tutImageView : UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .lightGray
        
        return imageView
    }()
    
    let view : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 50
        
        return view
    }()
    
    let label : UILabel = {
        let label = UILabel()
        
        label.text = "LOREM IPSUM DOLOR"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .center
        
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        
        label.text = "Классическая панграмма, условный, зачастую бессмысленный текст-заполнитель, вставляемый в макет страницы."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 3
        
        return label
    }()
    
    lazy var continueButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Продолжить", for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleContinueButton() {
        delegate?.handleContinue()
    }
    
    func setupViews() {
        addSubview(tutImageView)
        addSubview(view)
        view.addSubview(detailLabel)
        view.addSubview(label)
        view.addSubview(continueButton)
        
        tutImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(snp.centerY).offset(60)
        }
        
        view.snp.makeConstraints { (make) in
            make.top.equalTo(tutImageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(detailLabel.snp.top)
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(detailLabel.snp.bottom).offset(20)
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.height.equalTo(45)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
