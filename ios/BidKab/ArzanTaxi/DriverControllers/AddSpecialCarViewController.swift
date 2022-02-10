//
//  AddSpecialCarViewController.swift
//  ArzanTaxi
//
//  Created by Mukhamedali Tolegen on 24.02.18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AddSpecialCarViewController : UIViewController {
    
    let car = Helper.createInputField(withPlaceholder: "Mark of car", errorText: "")
    let additional = Helper.createInputField(withPlaceholder: "Description", errorText: "")
    
    lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        
        return button
    }()
    
    func setupViews() {
        view.addSubview(car)
        car.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(additional)
        additional.snp.makeConstraints { (make) in
            make.top.equalTo(car.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(additional.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    @objc func handleAddButton() {
        if let info = car.text, let text = additional.text, let token = UserDefaults.standard.string(forKey: "token") {
            let body : [String: String] = [
                "info" : info,
                "text" : text,
                "token" : token
            ]
            
            let indicator = SVProgressHUD.self
            indicator.show(withStatus: "Loading...")
            
            Alamofire.request(Constant.api.add_special, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("Add special: \(json)")
                        
                        indicator.dismiss()
                        indicator.showSuccess(withStatus: "Success")
                        indicator.dismiss(withDelay: 3)
                    }
                } else {
                    if let error = response.result.error {
                        indicator.dismiss()
                        indicator.showError(withStatus: "Not OK")
                        indicator.dismiss(withDelay: 3)
                        print(error.localizedDescription)
                        if error.localizedDescription == "The Internet connection appears to be offline." { }
                        else { }
                    }
                }
            })
        }
    }
}

