//
//  Helper.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/8/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import MaterialTextField

class Helper {
    static func setupOrderViewImage(with image: UIImage) -> UIImageView {
        let imageview = UIImageView(image: image)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }
    
    static func setupOrderViewImage() -> UIImageView {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .blue
        
        return imageView
    }
    
    static func setSearchButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.tintColor = .lightGray
        button.contentHorizontalAlignment = .left
        button.tag = tag
        return button
    }
    
    static func setupUnderline() -> UIView {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
    static func createInputField(withPlaceholder placeholder: String, errorText: String) -> MFTextField {
        let textField = MFTextField()
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.placeholderFont = UIFont.systemFont(ofSize: 10, weight: .medium)
        textField.placeholderColor = .lightGray
        textField.placeholderAnimatesOnFocus = true
        textField.underlineColor = .lightGray
        textField.underlineHeight = 1
        
        return textField
    }
    
    static func createOrderTextFieldForCargo(image : UIImage, placeholder : String, tag : Int, delegate : OrderCargoCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createOrderTextFieldForMoto(image : UIImage, placeholder : String, tag : Int, delegate : OrderMotoCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.textColor = .black
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createOrderTextFieldForIntercity(image : UIImage, placeholder : String, tag : Int, delegate : OrderIntercityCell, color: UIColor = .black) -> UIView {
        let view = UIView()
//        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
//        underlineView.backgroundColor = .gray
//        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = color
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.textColor = .black
        textField.tintColor = color
        textField.delegate = delegate
        
//        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
//        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createAutoTextFieldForIntercity(image : UIImage, placeholder : String, tag : Int, delegate : UITextFieldDelegate) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 12).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createAutoTextFieldForToy(image : UIImage, placeholder : String, tag : Int, delegate : DriverToyCreateCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .gray
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createAutoTextFieldForSpecial(image : UIImage, placeholder : String, tag : Int, delegate : DriverSpecialCreateCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .blue
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createAutoTextFieldForCargo(image : UIImage, placeholder : String, tag : Int, delegate : DriverCargoCreateCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createAutoTextFieldForMoto(image : UIImage, placeholder : String, tag : Int, delegate : DriverMotoCreateCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createOrderTextFieldForToy(image : UIImage, placeholder : String, tag : Int, delegate : OrderToyCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .gray
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createOrderTextFieldForSpecial(image : UIImage, placeholder : String, tag : Int, delegate : OrderSpecialCell) -> UIView {
        let view = UIView()
        let underlineView = UIView()
        let imageView = UIImageView(image: image)
        let textField = UITextField()
        
        underlineView.backgroundColor = .blue
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .blue
        
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = tag
        textField.delegate = delegate
        
        view.addSubview(underlineView)
        view.addSubview(imageView)
        view.addSubview(textField)
        
        underlineView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        underlineView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -1).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return view
    }
    
    static func createOrderLabel(image : UIImage, text : String, color: UIColor = .blue) -> UIView {
        let view = UIView()
        let imageView = UIImageView(image: image)
        let label = UILabel()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = color
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25)
        
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        return view
    }
    
    static func createTextField(placeholder : String) -> UITextField {
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
}
