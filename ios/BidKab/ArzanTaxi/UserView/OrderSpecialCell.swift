//
//  OrderSpecialCell.swift
//  ArzanTaxi
//
//  Created by MAC on 14.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import InputMask

class OrderSpecialCell: UICollectionViewCell, UITextFieldDelegate, MaskedTextFieldDelegateListener {
    var delegate : SpecialViewControllerDelegate?
    var maskedDelegate : MaskedTextFieldDelegate?
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    
    let cellID = "cell"
    var aPointText = ""
    var bPointText = ""
    var priceText = ""
    var dateText = ""
    var noteText = ""
    
    lazy var toTextField = Helper.createOrderTextFieldForSpecial(image: #imageLiteral(resourceName: "pointb"), placeholder: .localizedString(key: "to"), tag: 2, delegate: self)
    lazy var priceTextField = Helper.createOrderTextFieldForSpecial(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    lazy var noteTextField = Helper.createOrderTextFieldForSpecial(image: #imageLiteral(resourceName: "comment").withRenderingMode(.alwaysTemplate), placeholder: .localizedString(key: "note"), tag: 5, delegate: self)
    
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
    
    lazy var addPhotoLabel: UILabel = {
        let abl = UILabel()
        abl.text = .localizedString(key: "addPhotos")
        abl.textAlignment = .center
        abl.textColor = .black
        abl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return abl
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
        if bPointText == "" || priceText == "" {
            return
        }
        
        UserDefaults.standard.set(bPointText, forKey: "intercityBpointText")
        UserDefaults.standard.set(priceText, forKey: "intercityPriceText")
        
        delegate?.handleOrderButton(bPoint: bPointText, price: priceText, text: noteText, images: images)
    }
    
    func setupViews() {
        contentView.isUserInteractionEnabled = false
        addSubview(toTextField)
        addSubview(priceTextField)
        addSubview(noteTextField)
        addSubview(addPhotoLabel)
        addSubview(collectionView)
        addSubview(orderButton)
        
        toTextField.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
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
        
        addPhotoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(noteTextField.snp.bottom).offset(16)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotoLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(65)
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
        
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellID)
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

extension OrderSpecialCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}

extension OrderSpecialCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCollectionCell
        
        if images.count - 1 < indexPath.row {
            cell.orderImage.image = UIImage()
            print(images.count)
        } else {
            cell.orderImage.image = images[indexPath.row]
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if images.count - 1 < indexPath.row {
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


