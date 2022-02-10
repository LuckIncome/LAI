//
//  AddToiViewController.swift
//  ArzanTaxi
//
//  Created by Mukhamedali Tolegen on 24.02.18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

enum TextFieldError : String, Error {
    case price = "This line is required."
}

class AddToiViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func createPickerView(tag : Int) -> UIPickerView {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = tag
        
        return pickerView
    }
    
    var carMarks = [CarMark]()
    var carModels = [CarModel]()
    var carMarkNames = [String]()
    var carModelNames = [String]()
    
    var carMarkID = 0
    var carModelID = 0
    
    let indicator = SVProgressHUD.self
    
    let carMark = Helper.createInputField(withPlaceholder: .localizedString(key: "car_mark"), errorText: "")
    let carModel = Helper.createInputField(withPlaceholder: .localizedString(key: "car_model"), errorText: "")
    let price = Helper.createInputField(withPlaceholder: .localizedString(key: "toi_price"), errorText: "")
    
    lazy var carMarkPicker = createPickerView(tag : 0)
    lazy var carModelPicker = createPickerView(tag : 1)
    
    lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        
        return button
    }()
    
    func setupViews() {
        view.addSubview(carMark)
        carMark.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(carModel)
        carModel.snp.makeConstraints { (make) in
            make.top.equalTo(carMark.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(price)
        price.snp.makeConstraints { (make) in
            make.top.equalTo(carModel.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom).offset(30)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
    }
    
    @objc func handleAddButton() {
        if carMark.text == nil || carMark.text == "" {
            var error : Error? = nil
            error = self.error(withLocalizedDescription: "This line is required")
            carMark.setError(error, animated: true)
            
            return
        }
        
        if carModel.text == nil || carModel.text == "" {
            var error : Error? = nil
            error = self.error(withLocalizedDescription: "This line is required")
            carModel.setError(error, animated: true)
            
            return
        }
        
        if let price = price.text, let token = UserDefaults.standard.string(forKey: "token"), price != "" {
            let body : Parameters = [
                "car_mark_id" : carMarkID,
                "car_model_id" : carModelID,
                "year" : 2018,
                "color_id" : 1,
                "price" : price,
                "token" : token
            ]
            
            let indicator = SVProgressHUD.self
            indicator.show(withStatus: "Loading...")
            
            Alamofire.request(Constant.api.add_toi, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        print("Add toi: \(json)")
                        
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
        } else {
            var error : Error? = nil
            error = self.error(withLocalizedDescription: "This line is required")
            price.setError(error, animated: true)
        }
    }
    
    func error(withLocalizedDescription localizedDescription: String) -> Error? {
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: "ArzanTaksiError", code: 100, userInfo: userInfo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carMark.tag = 1
        carMark.delegate = self
        carModel.tag = 2
        carModel.delegate = self
        carModel.isEnabled = false
        price.delegate = self
        
        CarMark.getCarMarks { (carMarks) in
            self.indicator.show(withStatus: "Loading...")
            self.carMarks = carMarks
            self.indicator.dismiss()
        }
        
        view.backgroundColor = .white
        setupViews()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.inputView = carMarkPicker
            carMark.setError(nil, animated: true)
        } else if textField.tag == 2 {
            textField.inputView = carModelPicker
            carModel.setError(nil, animated: true)
        } else {
            price.setError(nil, animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            let id = carMarkID
            CarModel.getCarModel(id: id, completion: { (carModels) in
                self.indicator.show(withStatus: "Loading...")
                self.carModels.removeAll()
                self.carModels = carModels
                self.indicator.dismiss()
            })
            carModel.isEnabled = true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return carMarks.count
        } else if pickerView.tag == 1 {
            return carModels.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return carMarks[row].name
        } else if pickerView.tag == 1 {
            return carModels[row].name
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            carMark.text = carMarks[row].name
            carMarkID = carMarks[row].id!
        } else if pickerView.tag == 1 {
            carModel.text = carModels[row].name
            carModelID = carModels[row].id!
        }
    }
}
