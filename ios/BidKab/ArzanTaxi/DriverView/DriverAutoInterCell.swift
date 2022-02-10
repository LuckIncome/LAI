//
//  DriverAutoInterCell.swift
//  ArzanTaxi
//
//  Created by MAC on 14.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import InputMask
import Alamofire
import SwiftyJSON

class DriverAutoInterCell: UICollectionViewCell, UITextFieldDelegate, MaskedTextFieldDelegateListener  {
    
    var delegate : DriverIntercityViewControllerDelegate?
    var maskedDelegate : MaskedTextFieldDelegate?
    
    var aPointText = ""
    var bPointText = ""
    var priceText = ""
    var dateText = ""
    var noteText = ""
    var cities = [String]()
    var filtered = [String]()
    var fromDropDown = DropDown()
    var toDropDown = DropDown()
    var isSearching = false
    
    lazy var fromTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "pointa"), placeholder: .localizedString(key: "from"), tag: 1, delegate: self)
    lazy var toTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "pointb"), placeholder: .localizedString(key: "to"), tag: 2, delegate: self)
    lazy var priceTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "price"), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    lazy var noteTextField = Helper.createAutoTextFieldForIntercity(image: #imageLiteral(resourceName: "comment"), placeholder: .localizedString(key: "note"), tag: 5, delegate: self)
    
    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "create"), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 0, height: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleOrderButton), for: .touchUpInside)
        
        return button
    }()
    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        let locale = Locale(identifier: "en")
        
        picker.datePickerMode = .dateAndTime
        picker.locale = locale
        
        return picker
    }()
    
    @objc func handleOrderButton() {
        endEditing(true)
        if aPointText == "" || bPointText == "" || priceText == "" {
            return
        }
        
        UserDefaults.standard.set(aPointText, forKey: "intercityApointText")
        UserDefaults.standard.set(bPointText, forKey: "intercityBpointText")
        UserDefaults.standard.set(priceText, forKey: "intercityPriceText")
        
        delegate?.handleOrderButton(aPoint: aPointText, bPoint: bPointText, price: priceText, text: noteText)
    }
    
    func setupViews() {
        addSubview(fromTextField)
        addSubview(toTextField)
        addSubview(priceTextField)
        addSubview(noteTextField)
        addSubview(orderButton)
        
        fromTextField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        toTextField.snp.makeConstraints { (make) in
            make.top.equalTo(fromTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.top.equalTo(toTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        noteTextField.snp.makeConstraints { (make) in
            make.top.equalTo(priceTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        orderButton.snp.makeConstraints { (make) in
            make.top.equalTo(noteTextField.snp.bottom).offset(25)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCities()
        toDropDown.dismissMode = .manual
        toDropDown.direction = .bottom
        toDropDown.anchorView = toTextField
        toDropDown.width = self.contentView.bounds.size.width - 70
        toDropDown.bottomOffset = CGPoint(x: 35, y: toTextField.bounds.height+45)
        
        fromDropDown.dismissMode = .manual
        fromDropDown.direction = .bottom
        fromDropDown.anchorView = fromTextField
        fromDropDown.width = self.contentView.bounds.size.width - 70
        fromDropDown.bottomOffset = CGPoint(x: 35, y: fromTextField.bounds.height+45)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        toDropDown.dataSource = !isSearching ? cities : filtered
        fromDropDown.dataSource = !isSearching ? cities : filtered
    }
    
    func setCities() {
        Alamofire.request(Constant.api.cities, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    for i in json["result"].arrayValue {
                        self.cities.append(i["name"].stringValue)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    let formatter = DateFormatter()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4 {
            textField.inputView = datePicker
        } else if textField.tag == 3 {
            textField.keyboardType = .numberPad
        }
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            //            textField.text = textField.text?.currencyInputFormatting()
        } else if textField.tag == 4 {
            
        }
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            fromDropDown.selectionAction = { [unowned self] (index, item) in
                textField.text = item
                self.aPointText = item
            }
            
            if textField.text == nil || textField.text == "" {
                isSearching = false
                contentView.endEditing(true)
                fromDropDown.reloadAllComponents()
                fromDropDown.hide()
            } else {
                isSearching = true
                filtered = cities.filter({($0.lowercased().contains(textField.text!.lowercased()))})
                reloadData()
                fromDropDown.reloadAllComponents()
                fromDropDown.show()
            }
            
            if (textField.text?.count)! < 1 {
                isSearching = false
                fromDropDown.reloadAllComponents()
                fromDropDown.hide()
            }
            break
        case 2:
            toDropDown.selectionAction = { [unowned self] (index, item) in
                textField.text = item
                self.bPointText = item
            }
            
            if textField.text == nil || textField.text == "" {
                isSearching = false
                contentView.endEditing(true)
                toDropDown.reloadAllComponents()
                toDropDown.hide()
            } else {
                isSearching = true
                filtered = cities.filter({($0.lowercased().contains(textField.text!.lowercased()))})
                reloadData()
                toDropDown.reloadAllComponents()
                toDropDown.show()
            }
            
            if (textField.text?.count)! < 1 {
                isSearching = false
                toDropDown.reloadAllComponents()
                toDropDown.hide()
            }
            break
        default:
            break
        }
        
        print("asan")
        print(textField.text!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            aPointText = textField.text!
            //            if textField.text!.isEmpty {
            //                fromIsEmpty = true
            //            }
            break
        case 2:
            bPointText = textField.text!
            //            if textField.text!.isEmpty {
            //                toIsEmpty = true
            //            }
            break
        case 3:
            priceText = textField.text!
            //            if textField.text!.isEmpty {
            //                priceIsEmpty = true
            //            }
            
            break
        case 5:
            noteText = textField.text!
            break
        default:
            break
        }
    }
}
