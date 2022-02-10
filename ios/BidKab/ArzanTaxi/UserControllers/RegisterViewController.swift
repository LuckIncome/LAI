//
//  RegistrViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/11/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import MaterialTextField
import Alamofire
import SwiftyJSON
import FirebaseAuth
import SVProgressHUD

class RegisterViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var user : User?
    var phone : String?
    var code : String?
    var cities = [City]()
    var cityID = 0
    
    let inputFieldView : UIView = {
        let view = UIView()
        return view
    }()
    
    let createAccountLabel : UILabel = {
        let label = UILabel()
        label.text = "Создать аккаунт"
        label.font =  UIFont.systemFont(ofSize: 22, weight: .heavy)
        return label
    }()
    
    let lastName = Helper.createInputField(withPlaceholder: "Фамилия", errorText: "")
    let firstName = Helper.createInputField(withPlaceholder: "Имя", errorText: "")
    let patronymic = Helper.createInputField(withPlaceholder: "Отчество", errorText: "")
    let cityTextField = Helper.createInputField(withPlaceholder: "Город", errorText: "")
    
    lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    lazy var continueButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localizedString(key: "continue"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleContinueButton() {
        if let lastname = lastName.text, !lastname.isEmpty(), let firstname = firstName.text, !firstname.isEmpty(), let patronymic = patronymic.text, !patronymic.isEmpty(), let phoneNumber = phone, let code = code {
            let body : Parameters = [
                "surname": lastname,
                "name": firstname,
                "middle_name": patronymic,
                "phone" : phoneNumber.removingWhitespaces(),
                "verification_code": code,
                "city_id": cityID
            ]
            let indicator = SVProgressHUD.self
            indicator.show(withStatus: String.localizedString(key: "wait"))
            
            User.registerUser(body: body, completion: { (user, statusCode) in
                self.user = user
                
                if statusCode == Constant.statusCode.success {
                    print("Registered")
                    
                    indicator.dismiss()
                    UserDefaults.standard.set(self.phone!, forKey: "phoneNumber")
                    let navController = UINavigationController(rootViewController: HomeViewController())
                    let leftController = LeftMenuController()
                    leftController.user = self.user
                    let slideController = SWRevealViewController(rearViewController: leftController, frontViewController: navController)
                    UIApplication.shared.keyWindow?.rootViewController = slideController
                    
                    self.dismiss(animated: true, completion: {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    })
                } else {
                    indicator.showError(withStatus: String.localizedString(key: "wentWrong"))
                }
            })
        } else {
            indicator.showError(withStatus: String.localizedString(key: "fields"))
        }
    }
    
    func setupViews() {
        view.addSubview(inputFieldView)
        inputFieldView.addSubview(lastName)
        inputFieldView.addSubview(firstName)
        inputFieldView.addSubview(patronymic)
        inputFieldView.addSubview(cityTextField)
        
        view.addSubview(createAccountLabel)
        view.addSubview(continueButton)

        inputFieldView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(50)
            make.right.equalTo(-70)
            make.height.equalTo(300)
        }

        createAccountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.bottom.equalTo(inputFieldView.snp.top).offset(-15)
        }
        
        lastName.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }

        firstName.snp.makeConstraints { (make) in
            make.top.equalTo(lastName.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }

        patronymic.snp.makeConstraints { (make) in
            make.top.equalTo(firstName.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        cityTextField.snp.makeConstraints { (make) in
            make.top.equalTo(patronymic.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(inputFieldView.snp.bottom).offset(10)
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(45)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "QazTaxi"
        
        setupViews()
        
        cityTextField.tag = 0
        cityTextField.delegate = self
        
        City.getCities { (cities) in
            indicator.show(withStatus: "Loading...")
            self.cities = cities
            indicator.dismiss()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            textField.inputView = pickerView
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = cities[row].name
        if let id = cities[row].id {
            cityID = id
        }
    }
}
