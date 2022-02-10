//
//  OrderMotoCell.swift
//  ArzanTaxi
//
//  Created by MAC on 11.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import InputMask

class OrderMotoCell: UICollectionViewCell, UITextViewDelegate, UITextFieldDelegate, MaskedTextFieldDelegateListener {
    var maskedDelegate : MaskedTextFieldDelegate?
    var delegate : MotoViewControllerDelegate?
    
    var aPointText = ""
    var bPointText = ""
    var priceText = ""
    var text = ""
    
    var fromIsEmpty = true
    var toIsEmpty = true
    var priceIsEmpty = true
    
    lazy var from = Helper.createOrderTextFieldForMoto(image: #imageLiteral(resourceName: "pointa"), placeholder: .localizedString(key: "from"), tag: 1, delegate: self)
    lazy var to = Helper.createOrderTextFieldForMoto(image: #imageLiteral(resourceName: "pointb"), placeholder: .localizedString(key: "to"), tag: 2, delegate: self)
    lazy var price = Helper.createOrderTextFieldForMoto(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    
    lazy var descriptionView : UIView = {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "comment-1").withRenderingMode(.alwaysTemplate))
        let textView = UITextView()
        
        textView.text = .localizedString(key: "note")
        textView.textColor = .lightGray
        
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        
        underlineView.backgroundColor = .blue
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textView)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3).isActive = true
        
        return view
    }()
    
    let docLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "document")
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let docSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .blue
        return switcher
    }()
    
    let torgLabel : UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "torg")
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let torgSwitcher : UISwitch = {
        let switcher = UISwitch()
        switcher.onTintColor = .blue
        return switcher
    }()
    
    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "order"), for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleOrderButton), for: .touchUpInside)
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 0, height: 10)
        return button
    }()
    
    @objc func handleOrderButton() {
        endEditing(true)
        if aPointText == "" || bPointText == "" || priceText == "" {
            return
        }
        
        delegate?.handleOrderButton(aPoint: aPointText, bPoint: bPointText, price: priceText, date: "", text : text)
        
        aPointText = ""
        bPointText = ""
        priceText = ""
        text = ""
    }
    
    func setupViews() {
        addSubview(from)
        addSubview(to)
        addSubview(price)
        addSubview(descriptionView)
        //addSubview(docLabel)
        //addSubview(docSwitcher)
        //addSubview(torgSwitcher)
        //addSubview(torgLabel)
        addSubview(orderButton)
        
        from.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        to.snp.makeConstraints { (make) in
            make.top.equalTo(from.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        price.snp.makeConstraints { (make) in
            make.top.equalTo(to.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(price.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
//        docLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(descriptionView.snp.bottom).offset(15)
//            make.left.equalTo(30)
//        }
//
//        docSwitcher.snp.makeConstraints { (make) in
//            make.centerY.equalTo(docLabel)
//            make.left.equalTo(docLabel.snp.right)
//        }
//
//        torgSwitcher.snp.makeConstraints { (make) in
//            make.right.equalTo(-30)
//            make.centerY.equalTo(docSwitcher)
//        }
//
//        torgLabel.snp.makeConstraints { (make) in
//            make.right.equalTo(torgSwitcher.snp.left)
//            make.centerY.equalTo(torgSwitcher)
//        }
        
        orderButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionView.snp.bottom).offset(25)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
        
        //docSwitcher.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        //torgSwitcher.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            textField.keyboardType = .numberPad
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = String.localizedString(key: "cargo_note")
            textView.textColor = UIColor.lightGray
        } else {
            text = textView.text
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 1:
            aPointText = textField.text!
            if textField.text!.isEmpty {
                fromIsEmpty = true
            }
            break
        case 2:
            bPointText = textField.text!
            if textField.text!.isEmpty {
                toIsEmpty = true
            }
            break
        case 3:
            textField.keyboardType = .numberPad
            priceText = textField.text!
            if textField.text!.isEmpty {
                priceIsEmpty = true
            }
            break
        default:
            break
        }
    }
}
