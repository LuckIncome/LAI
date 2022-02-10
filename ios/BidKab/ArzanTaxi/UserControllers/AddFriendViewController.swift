//
//  AddFriendViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import InputMask
import FirebaseMessaging

class AddFriendViewController : UIViewController, MaskedTextFieldDelegateListener {
    
    var maskedDelegate : MaskedTextFieldDelegate?
    let defaults = UserDefaults.self
    
//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    let phoneNumber = Helper.createInputField(withPlaceholder: .localizedString(key: "phone_number"), errorText: "")
    
    lazy var sendRequestButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "send_request"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        
        return button
    }()
    
    func setupViews() {
//        view.addSubview(backgroundImage)
        view.addSubview(phoneNumber)
        view.addSubview(sendRequestButton)
        
//        backgroundImage.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalToSuperview()
//        }
        
        phoneNumber.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.left.equalTo(50)
            make.right.equalTo(-70)
        }
        
        sendRequestButton.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumber.snp.bottom).offset(50)
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        navigationItem.title = .localizedString(key: "friend_position")
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "{+234} [000] [000] [00] [00]")
        maskedDelegate?.listener = self
        phoneNumber.delegate = maskedDelegate
        
        phoneNumber.keyboardType = .phonePad
        
        setupViews()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        maskedDelegate?.put(text: "+234 ", into: phoneNumber)
    }
}
