//
//  PromocodeViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import MaterialTextField
import InputMask
import Alamofire
import SwiftyJSON

class PromocodeViewController : UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate : MaskedTextFieldDelegate?
    var navTitle : String?
    var afterCompletion: (()->())?

    let promocodeField = Helper.createInputField(withPlaceholder: .localizedString(key: "enter_promocode"), errorText: "")
    
    lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "add"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePromoCode), for: .touchUpInside)
        
        return button
    }()
    
    let shareDescriptionLabel : UILabel = {
        let label = UILabel()
        
        label.text = .localizedString(key: "promo_label")
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 7
        
        return label
    }()
    
    let promocodeView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        
        return view
    }()

    lazy var backgroundBlurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewPressed)))

        return view
    }()
    
    func setupViews() {
        view.addSubview(backgroundBlurView)
        view.addSubview(promocodeView)
        promocodeView.addSubview(shareDescriptionLabel)
        promocodeView.addSubview(promocodeField)
        promocodeView.addSubview(addButton)
        
        backgroundBlurView.snp.makeConstraints { (back) in
            back.edges.equalToSuperview()
        }

        promocodeView.snp.makeConstraints { (promocodeView) in
            promocodeView.center.equalToSuperview()
            promocodeView.width.equalToSuperview().multipliedBy(0.8)
            promocodeView.height.equalTo(250)
        }

        shareDescriptionLabel.snp.makeConstraints { (shareDescriptionLabel) in
            shareDescriptionLabel.centerX.equalToSuperview()
            shareDescriptionLabel.top.equalToSuperview().offset(20)
            shareDescriptionLabel.width.equalToSuperview().multipliedBy(0.8)
            shareDescriptionLabel.bottom.equalTo(promocodeField.snp_topMargin).offset(-10)
        }

        promocodeField.snp.makeConstraints { (promocodeField) in
            promocodeField.bottom.equalTo(addButton.snp_topMargin).offset(-20)
            promocodeField.centerX.equalToSuperview()
            promocodeField.width.equalToSuperview().multipliedBy(0.7)
        }

        addButton.snp.makeConstraints { (addButton) in
            addButton.bottom.equalToSuperview().offset(-20)
            addButton.centerX.equalToSuperview()
            addButton.width.equalTo(promocodeField)
            addButton.height.equalTo(40)
        }

    }

    @objc func backViewPressed() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handlePromoCode() {
        if let promo = promocodeField.text, let token = UserDefaults.standard.string(forKey: "token") {
            if promo.count == 7 {
                let body : Parameters = ["token" : token, "promo_code" : promo]
                Alamofire.request(Constant.api.add_promo_code, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    switch response.result {
                    case .success:
                        self.dismiss(animated: true, completion: {
                            if let block = self.afterCompletion {
                                block()
                            }
                        })
                        break
                    case .failure(let error):
                        print("error promocode: \(error)")
                        break
                    }
                }
            } else {
                promocodeField.setError(NSError(domain: "Number have to consist 7-digit", code: 1, userInfo: nil), animated: true)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        promocodeField.keyboardType = .numberPad
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "[0000000]")
        maskedDelegate?.listener = self
        promocodeField.delegate = maskedDelegate
        
        setupViews()
    }
}
