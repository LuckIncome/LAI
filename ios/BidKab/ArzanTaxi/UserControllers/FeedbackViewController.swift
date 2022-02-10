//
//  FeedbackViewController.swift
//  ArzanTaxi
//
//  Created by yung meg on 3/2/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import SwiftyJSON

class FeedbackViewController : UIViewController {
    
    var phone = ""
    var id : Int?
    var driverID : Int?
    
    let feedbackLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "feedback_label")
        label.textColor = .blue
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
//    let feedbackLabel2 : UILabel = {
//        let label = UILabel()
//        
//        label.text = .localizedString(key: "feedback_label_2")
//        label.textColor = .black
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.numberOfLines = 2
//        
//        return label
//    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile_image-1")
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let fullName : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    lazy var phoneButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .blue
        button.setImage(#imageLiteral(resourceName: "phone"), for: .normal)
        button.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
        return button
    }()
    
    let ratingView : CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = false
        view.rating = 4
        view.settings.emptyBorderColor = .gray
        view.settings.filledColor = .yellow
        view.settings.filledBorderColor = .gray
        view.settings.textColor = .gray
        view.settings.starSize = 15
        view.settings.fillMode = .half
        return view
    }()
    
    let carLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
//    let numberView : UIView = {
//        let view = UIView()
//
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.black.cgColor
//        view.layer.cornerRadius = 5
//
//        return view
//    }()
    
    let numberLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let userRatingView : CosmosView = {
        let view = CosmosView()
        view.settings.emptyBorderColor = .blue
        view.settings.filledColor = .yellow
        view.settings.filledBorderColor = .blue
        view.rating = 0
        view.tintColor = .blue
        view.settings.starSize = 35
        view.settings.fillMode = .half
        return view
    }()
    
    lazy var commentTextView : UITextView = {
        let view = UITextView()
        view.delegate = self
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 25
        view.layer.borderColor = UIColor.blue.cgColor
        view.textColor = .black
//        view.backgroundColor = .paleGray
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    lazy var placeholderLabel: UILabel = {
        let pll = UILabel()
        pll.textColor = .gray
        pll.font = UIFont.systemFont(ofSize: 20)
        pll.text = String.localizedString(key: "comment")
        
        return pll
    }()
    
    lazy var sendButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "send"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .yellow
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleSendButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var closeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "close"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSendButton() {
        if let token = UserDefaults.standard.string(forKey: "token"), let id = id, let driverID = driverID {
            var body = Parameters()
            if commentTextView.text == nil {
                body = [
                    "token" : token,
                    "parent_id" : id,
                    "parent_type" : "taxi_orders",
                    "driver_id" : driverID,
                    "rating" : userRatingView.rating,
                    "text" : ""
                ]
            } else {
                guard let text = commentTextView.text else { return }
                body = [
                    "token" : token,
                    "parent_id" : id,
                    "parent_type" : "taxi_orders",
                    "driver_id" : driverID,
                    "rating" : userRatingView.rating,
                    "text" : text
                ]
            }

            indicator.show()
            Alamofire.request(Constant.api.feedback, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        if json["statusCode "].intValue == Constant.statusCode.success {
                            indicator.showSuccess(withStatus: "Спасибо за отзыв")
                            indicator.dismiss(withDelay: 1.3)
                            self.carLabel.text = nil
                            self.commentTextView.text = nil
                            self.driverID = nil
                            self.fullName.text = nil
                            self.id = nil
                            self.numberLabel.text = nil
                            
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.setupAppdelegate()
                            }
                        } else {
                            indicator.showError(withStatus: "Error")
                            indicator.dismiss(withDelay: 1.3)
                        }
                    }
                } else {
                    print(response.result.error!.localizedDescription)
                }
            })
        }
    }
    
    @objc func handleCloseButton() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setupAppdelegate()
        }
    }
    
    @objc func handleCall() {
        phone = phone.contains("+") ? phone : "+\(phone)"
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func setupViews() {
        [feedbackLabel, profileImage, phoneButton, fullName, ratingView, carLabel, userRatingView, closeButton, sendButton, commentTextView, placeholderLabel].forEach { (v) in
            view.addSubview(v)
        }
        
//        numberView.addSubview(numberLabel)
        
        feedbackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(UIViewController.heightNavBar + 45)
            make.left.right.equalToSuperview()
        }
        
//        feedbackLabel2.snp.makeConstraints { (make) in
//            make.top.equalTo(feedbackLabel.snp.bottom).offset(7)
//            make.left.right.equalToSuperview()
//        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(feedbackLabel.snp.bottom).offset(30)
            make.left.equalTo(30)
            make.width.height.equalTo(60)
        }
        
        phoneButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profileImage)
            make.right.equalTo(-30)
            make.width.height.equalTo(60)
        }
        
        fullName.snp.makeConstraints { (make) in
            make.top.equalTo(profileImage)
            make.left.equalTo(profileImage.snp.right).offset(8)
            make.right.equalTo(phoneButton.snp.left).offset(-8)
        }
        
        ratingView.snp.makeConstraints { (make) in
            make.top.equalTo(fullName.snp.bottom).offset(4)
            make.left.equalTo(fullName)
        }
        
        carLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ratingView.snp.bottom).offset(4)
            make.left.right.equalTo(fullName)
        }
        
//        numberView.snp.makeConstraints { (make) in
//            make.top.equalTo(carLabel.snp.bottom).offset(15)
//            make.centerX.equalToSuperview()
//            make.width.equalTo(100)
//            make.height.equalTo(30)
//        }
        
//        numberLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(carLabel)
//            make.left.equalTo(carLabel.snp.right).offset(4)
//        }
        
        userRatingView.snp.makeConstraints { (make) in
            make.top.equalTo(carLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userRatingView.snp.bottom).offset(75)
            make.centerX.equalToSuperview()
        }
        
        commentTextView.snp.makeConstraints { (make) in
            make.center.equalTo(placeholderLabel)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(130)
            make.bottom.equalTo(sendButton.snp.top).offset(-10)
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(closeButton.snp.top).offset(-10)
            make.height.equalTo(45)
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalToSuperview()
            make.height.equalTo(45)
        }

        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBarTransparent(title: nil, shadowImage: false)
        
        setupViews()
    }
}

extension FeedbackViewController: UITextViewDelegate {    
    func textViewDidChange(_ textView: UITextView) {
        textView.text.isEmpty ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
    }
}
