//
//  NewHelpCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 10/2/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class NewHelpCell: UITableViewCell {
    
    var action: ((Int) -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(linkLabelTapAction(_:)))
        linkLabel.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(linkLabel)
        linkLabel.isUserInteractionEnabled = true
        
        let baseWidth: CGFloat = contentView.frame.width / 3
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.left.equalTo(contentView.snp.left).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
            make.width.equalTo(baseWidth)
        }
        
        linkLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.right.equalTo(contentView.snp.right)
        }
    }
    
    @objc private func linkLabelTapAction(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view as? UILabel else { return }
        let index = senderView.tag - 1
        action?(index)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .blue
        
        return label
    }()
}
