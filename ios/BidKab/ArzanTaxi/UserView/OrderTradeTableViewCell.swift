//
//  OrderTradeTableViewCell.swift
//  ArzanTaxi
//
//  Created by Nursultan on 08.12.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class OrderTradeTableViewCell: UITableViewCell {

    var driverId: Int?
    var timerForProgressView: Timer?
    var isTimerStarted: Bool = false {
        didSet{
            if isTimerStarted {
                runTimerForProgressView()
            } else {
                timerForProgressView?.invalidate()
            }
        }
    }
    var block: ((Int)->())?


    lazy var orderTradeView: UIView = {
        let orderTradeView = UIView()
        orderTradeView.backgroundColor = .white
        orderTradeView.layer.cornerRadius = 30
        return orderTradeView
    }()

    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.tintColor = .blue
        progressView.progressTintColor = .blue
        progressView.progress = 1
        return progressView
    }()

    lazy var driverImageView: UIImageView = {
        let driverImageView = UIImageView()
        driverImageView.image = #imageLiteral(resourceName: "profile_image")
        driverImageView.layer.cornerRadius = 30
        driverImageView.layer.masksToBounds = true
        return driverImageView
    }()

    lazy var driverCarLabel: UILabel = {
        let driverCarLabel = UILabel()
        driverCarLabel.text = "Honda Accord"
        driverCarLabel.textColor = .blue
        driverCarLabel.font = UIFont.systemFont(ofSize: 18)
        return driverCarLabel
    }()

    lazy var driverFullNameLabel: UILabel = {
        let driverFullNameLabel = UILabel()
        driverFullNameLabel.text = "Arman Kuanysh"
        driverFullNameLabel.textColor = .blue
        driverFullNameLabel.font = UIFont.systemFont(ofSize: 18)
        return driverFullNameLabel
    }()

    lazy var priceOfOrderLabel: UILabel = {
        let priceOfOrderLabel = UILabel()
        priceOfOrderLabel.text = "400 т"
        priceOfOrderLabel.textColor = .blue
        priceOfOrderLabel.font = UIFont.systemFont(ofSize: 20)
        return priceOfOrderLabel
    }()
    
    lazy var getYourPriceButton: UIButton = {
        let gypb = UIButton(type: .system)
        gypb.backgroundColor = .blue
        gypb.setTitle(.localizedString(key: "getYourPrice"), for: .normal)
        gypb.setTitleColor(.white, for: .normal)
        gypb.layer.cornerRadius = 10
        gypb.layer.masksToBounds = true
        return gypb
    }()

    lazy var ratingImageView: UIImageView = {
        let ratingImageView = UIImageView()
        ratingImageView.image = #imageLiteral(resourceName: "vip_taxi")
        return ratingImageView
    }()

    lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel()
        ratingLabel.textColor = .blue
        ratingLabel.font = UIFont.systemFont(ofSize: 18)
        ratingLabel.text = "4.8"
        return ratingLabel
    }()

    lazy var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.textColor = .blue
        distanceLabel.font = UIFont.systemFont(ofSize: 18)
        distanceLabel.text = "900 m"
        return distanceLabel
    }()

    let compassImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "compass"))
        imageView.tintColor = .blue
        return imageView
    }()

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .clear
        cancelButton.setTitle(.localizedString(key: "cancel"), for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.masksToBounds = true
        return cancelButton
    }()

    lazy var acceptButton: UIButton = {
        let acceptButton = UIButton(type: .system)
        acceptButton.backgroundColor = .blue
        acceptButton.setTitle(.localizedString(key: "accept"), for: .normal)
        acceptButton.setTitleColor(.white, for: .normal)
        acceptButton.layer.cornerRadius = 10
        acceptButton.layer.masksToBounds = true
        return acceptButton
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        setupAllViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func runTimerForProgressView(){
        timerForProgressView = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            let progress = self.progressView.progress - 0.06
            if progress < 0 {
                if let block = self.block{
                    block(self.driverId!)
                }
                self.progressView.setProgress(1, animated: true)
                self.timerForProgressView?.invalidate()
            } else {
                self.progressView.setProgress(progress, animated: true)
            }
        })
    }

    private func setupAllViews(){
        contentView.isUserInteractionEnabled = false
        
        addSubview(orderTradeView)
        orderTradeView.snp.makeConstraints { (orderTradeView) in
            orderTradeView.left.top.equalTo(self).offset(10)
            orderTradeView.right.bottom.equalTo(self).offset(-10)
        }

        orderTradeView.addSubview(progressView)
        progressView.snp.makeConstraints { (progressView) in
            progressView.left.top.right.equalTo(orderTradeView)
            progressView.height.equalTo(5)
        }
        orderTradeView.addSubview(driverImageView)
        driverImageView.snp.makeConstraints { (driverImageView) in
            driverImageView.left.top.equalTo(orderTradeView).offset(10)
            driverImageView.height.width.equalTo(60)
        }
        orderTradeView.addSubview(driverCarLabel)
        driverCarLabel.snp.makeConstraints { (driverCarLabel) in
            driverCarLabel.left.equalTo(driverImageView.snp.right).offset(10)
            driverCarLabel.top.equalTo(driverImageView).offset(5)
        }
        orderTradeView.addSubview(driverFullNameLabel)
        driverFullNameLabel.snp.makeConstraints { (driverFullNameLabel) in
            driverFullNameLabel.left.equalTo(driverCarLabel)
            driverFullNameLabel.top.equalTo(driverCarLabel.snp.bottom).offset(5)
        }
        orderTradeView.addSubview(priceOfOrderLabel)
        priceOfOrderLabel.snp.makeConstraints { (priceOfOrderLabel) in
            priceOfOrderLabel.right.equalTo(orderTradeView).offset(-15)
            priceOfOrderLabel.top.equalTo(driverImageView)
        }
        orderTradeView.addSubview(ratingImageView)
        ratingImageView.snp.makeConstraints { (ratingImageView) in
            ratingImageView.left.equalTo(driverFullNameLabel)
            ratingImageView.top.equalTo(driverFullNameLabel.snp.bottom).offset(5)
            ratingImageView.width.height.equalTo(25)
        }
        orderTradeView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { (ratingLabel) in
            ratingLabel.left.equalTo(ratingImageView.snp.right).offset(5)
            ratingLabel.top.equalTo(ratingImageView)
        }
        orderTradeView.addSubview(distanceLabel)
        distanceLabel.snp.makeConstraints { (distanceLabel) in
            distanceLabel.right.equalTo(orderTradeView).offset(-15)
            distanceLabel.top.equalTo(ratingLabel)
        }
        orderTradeView.addSubview(compassImage)
        compassImage.snp.makeConstraints { (compass) in
            compass.width.equalTo(15)
            compass.height.equalTo(20)
            compass.centerY.equalTo(distanceLabel)
            compass.right.equalTo(distanceLabel.snp.left).offset(-4)
        }
        orderTradeView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (cancelButton) in
            cancelButton.left.equalTo(orderTradeView).offset(15)
            cancelButton.top.equalTo(ratingImageView.snp.bottom).offset(16)
            cancelButton.height.equalTo(40)
            cancelButton.right.equalTo(orderTradeView.snp.centerX).offset(-10)
        }
        orderTradeView.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { (acceptButton) in
            acceptButton.right.equalTo(orderTradeView).offset(-15)
            acceptButton.width.height.bottom.equalTo(cancelButton)
        }
        
//        orderTradeView.addSubview(getYourPriceButton)
//        getYourPriceButton.snp.makeConstraints ({ (getPriceButton) in
//            getPriceButton.top.equalTo(acceptButton.snp.bottom).offset(20)
//            getPriceButton.width.equalToSuperview().dividedBy(2)
//            getPriceButton.centerX.equalToSuperview()
//            getPriceButton.height.equalTo(cancelButton)
//        })

    }

}
