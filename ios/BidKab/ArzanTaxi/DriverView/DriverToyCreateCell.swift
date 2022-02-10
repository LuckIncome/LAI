//
//  DriverToyCreateCell.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import InputMask

class DriverToyCreateCell: UICollectionViewCell, UITextFieldDelegate, MaskedTextFieldDelegateListener {
    var delegate : DriverCargoControllerDelegate?
    var maskedDelegate : MaskedTextFieldDelegate?
    let imagePicker = UIImagePickerController()
    var aPointText = ""
    var bPointText = ""
    var priceText = ""
    var dateText = ""
    var noteText = ""
    var images = [UIImage]()
    let cellId = "cellId"
    
    lazy var priceTextField = Helper.createAutoTextFieldForToy(image: #imageLiteral(resourceName: "tenge"), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    lazy var noteTextField = Helper.createAutoTextFieldForToy(image: #imageLiteral(resourceName: "description"), placeholder: .localizedString(key: "note"), tag: 5, delegate: self)
    
    lazy var orderButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "create"), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleOrderButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addPhotosLabel: UILabel = {
        let apl = UILabel()
        apl.text = "Add Photos"
        apl.textAlignment = .center
        apl.textColor = .blue
        apl.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        return apl
    }()

    
    let datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        let locale = Locale(identifier: "en")
        
        picker.datePickerMode = .dateAndTime
        picker.locale = locale
        
        return picker
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    @objc func handleOrderButton() {
        endEditing(true)
        if priceText == "" {
            return
        }
        
        UserDefaults.standard.set(priceText, forKey: "intercityPriceText")
        
        delegate?.handleOrderButton(price: priceText, text: noteText, images: images)
    }
    
    func setupViews() {
        addSubview(priceTextField)
        addSubview(noteTextField)
        addSubview(orderButton)
        addSubview(collectionView)
        addSubview(addPhotosLabel)
        
        priceTextField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        noteTextField.snp.makeConstraints { (make) in
            make.top.equalTo(priceTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        addPhotosLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noteTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotosLabel.snp.bottom).offset(15)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.size.equalTo(65)
        }
        
        orderButton.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellId)
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

extension DriverToyCreateCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}

extension DriverToyCreateCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageCollectionCell
        
        if images.count > indexPath.row {
            print(images.count)
            cell.image.image = images[indexPath.row]
        } else {
            cell.image.image = #imageLiteral(resourceName: "nav_bar_plus")
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images.count == indexPath.row {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.contentView.window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
