//
//  OrderCargoCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import InputMask

class OrderCargoCell : UICollectionViewCell, UITextViewDelegate, UITextFieldDelegate, MaskedTextFieldDelegateListener {
    
    var maskedDelegate : MaskedTextFieldDelegate?
    var delegate : CargoViewControllerDelegate?
    let imagePicker = UIImagePickerController()
    let cellID = "cell"
    var images: [UIImage?] = []
    
    var aPointText = ""
    var bPointText = ""
    var priceText = ""
    var text = ""
    
    var fromIsEmpty = true
    var toIsEmpty = true
    var priceIsEmpty = true
    
    lazy var from = Helper.createOrderTextFieldForCargo(image: #imageLiteral(resourceName: "pointa"), placeholder: .localizedString(key: "from"), tag: 1, delegate: self)
    lazy var to = Helper.createOrderTextFieldForCargo(image: #imageLiteral(resourceName: "pointb"), placeholder: .localizedString(key: "to"), tag: 2, delegate: self)
    lazy var price = Helper.createOrderTextFieldForCargo(image: #imageLiteral(resourceName: "price").withRenderingMode(.alwaysTemplate), placeholder: .localizedString(key: "price"), tag: 3, delegate: self)
    
    lazy var descriptionView : UIView = {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "comment-1").withRenderingMode(.alwaysTemplate))
        let textView = UITextView()
        textView.text = .localizedString(key: "note")
        textView.textColor = .lightGray
        textView.isEditable = true
        textView.font = UIFont.systemFont(ofSize: 14)
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
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
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
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .init(width: 0, height: 10)
        button.addTarget(self, action: #selector(handleOrderButton), for: .touchUpInside)
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
    
    @objc func handleOrderButton() {
        endEditing(true)
        if aPointText == "" || bPointText == "" || priceText == "" {
            return
        }
    
        delegate?.handleOrderButton(aPoint: aPointText, bPoint: bPointText, price: priceText, document : docSwitcher.isOn, bargain : torgSwitcher.isOn, text : text, images: (images as! [UIImage]))
        
        aPointText = ""
        bPointText = ""
        priceText = ""
        text = ""
    }
    
    func setupViews() {
        contentView.isUserInteractionEnabled = false
        
        addSubview(from)
        addSubview(to)
        addSubview(price)
        addSubview(descriptionView)
        addSubview(addPhotoLabel)
        addSubview(collectionView)
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
        
        addPhotoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionView.snp.bottom).offset(16)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(25)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(addPhotoLabel.snp.bottom).offset(16)
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
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: cellID)
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

extension OrderCargoCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            images.append(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
        self.collectionView.reloadData()
    }
}

extension OrderCargoCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
        return CGSize(width: 100, height: 100)
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

