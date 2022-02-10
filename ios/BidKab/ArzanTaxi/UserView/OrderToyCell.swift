//
//  OrderToyCell.swift
//  ArzanTaxi
//
//  Created by MAC on 14.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import InputMask

class OrderToyCell: UICollectionViewCell, UITextFieldDelegate, MaskedTextFieldDelegateListener {
    var delegate : ToyTaxiViewControllerDelegate?
    var maskedDelegate : MaskedTextFieldDelegate?
    
    var priceText = ""
    var dateText = ""
    var noteText = ""
    
    lazy var priceTextField = Helper.createOrderTextFieldForToy(image: #imageLiteral(resourceName: "tenge"), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    lazy var dateTextField = Helper.createOrderTextFieldForToy(image: #imageLiteral(resourceName: "intercity_calendar"), placeholder: .localizedString(key: "date"), tag: 4, delegate: self)
    lazy var noteTextField = Helper.createOrderTextFieldForToy(image: #imageLiteral(resourceName: "description"), placeholder: .localizedString(key: "note"), tag: 5, delegate: self)
    
    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "order"), for: .normal)
        button.backgroundColor = .blue
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
        if priceText == "" || dateText == "" {
            return
        }
        
        UserDefaults.standard.set(priceText, forKey: "intercityPriceText")
        UserDefaults.standard.set(dateText, forKey: "intercityDateText")
        
        delegate?.handleOrderButton(price: priceText, date: dateText, text: noteText)
    }
    
    func setupViews() {
        addSubview(priceTextField)
        addSubview(dateTextField)
        addSubview(noteTextField)
        addSubview(orderButton)
        
        priceTextField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        dateTextField.snp.makeConstraints { (make) in
            make.top.equalTo(priceTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        noteTextField.snp.makeConstraints { (make) in
            make.top.equalTo(dateTextField.snp.bottom)
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
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let formatter = DateFormatter()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 4 {
            textField.inputView = datePicker
        } else if textField.tag == 3 {
            textField.keyboardType = .numberPad
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 3 {
            //            textField.text = textField.text?.currencyInputFormatting()
        } else if textField.tag == 4 {
            
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 3:
            priceText = textField.text!
            
            break
        case 4:
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            textField.text = formatter.string(from: datePicker.date)
            dateText = textField.text!
            break
        case 5:
            noteText = textField.text!
            break
        default:
            break
        }
    }
}
