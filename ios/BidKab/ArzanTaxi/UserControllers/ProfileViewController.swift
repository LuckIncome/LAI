//
//  ProfileViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit
import MaterialTextField
import Alamofire
import SwiftyJSON

class ProfileViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    var cities = [City]()
    var cityID : Int?
    var selectedImage: UIImage?
    var user : User? {
        didSet {
            lastName.text = user?.surname
            firstName.text = user?.name
            patronymic.text = user?.middle_name
            city.text = user?.city
            cityID = user?.city_id
            if let avatar = user?.avatar {
                let url = URL(string: avatar)
                profileImage.kf.setImage(with: url, placeholder: UIImage(named: "profile_image"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            saveButton.isEnabled = true
        }
    }
    var navTitle : String?

//    let backgroundImage : UIImageView = {
//        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_background"))
//        
//        return imageView
//    }()
    
    let profileImage : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile_image"))

        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50

        
        return imageView
    }()
    
    let inputFieldView : UIView = {
        let view = UIView()
        
        return view
    }()
    
    let lastName = Helper.createInputField(withPlaceholder: .localizedString(key: "surname"), errorText: "")
    let firstName = Helper.createInputField(withPlaceholder: .localizedString(key: "name"), errorText: "")
    let patronymic = Helper.createInputField(withPlaceholder: .localizedString(key: "middle_name"), errorText: "")
    let city = Helper.createInputField(withPlaceholder: .localizedString(key: "city"), errorText: "")
    
    lazy var pickerView : UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    lazy var saveButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(String.localizedString(key: "save"), for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()

    @objc func pickImage(sender : UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func setupViews() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        gesture.delegate = self
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickImage)))
        profileImage.isUserInteractionEnabled = true
//        view.addSubview(backgroundImage)
        view.addSubview(profileImage)
        view.addSubview(inputFieldView)
        inputFieldView.addSubview(lastName)
        inputFieldView.addSubview(firstName)
        inputFieldView.addSubview(patronymic)
        inputFieldView.addSubview(city)
        view.addSubview(saveButton)
        
//        backgroundImage.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalToSuperview()
//        }
        
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        inputFieldView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(50)
            make.right.equalTo(-70)
            make.height.equalTo(210)
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
        
        city.snp.makeConstraints { (make) in
            make.top.equalTo(patronymic.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.left.equalTo(70)
            make.right.equalTo(-70)
            make.height.equalTo(45)
            make.bottom.equalTo(-50)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var langImage = UIImage()
//        if UserDefaults.standard.string(forKey: "language") == "kz" {
//            langImage = UIImage(named: "kazakh")!
//        } else if UserDefaults.standard.string(forKey: "language") == "ru" {
//            langImage = UIImage(named: "russian")!
//        } else if UserDefaults.standard.string(forKey: "language") == "en" {
//            langImage = UIImage(named: "english")!
//        }
//        
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))
        
        navigationItem.title = String.localizedString(key: "edit_profile")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        view.backgroundColor = .white
        
        setupViews()
        
        city.tag = 0
        city.delegate = self
        
        City.getCities { (cities) in
            indicator.show(withStatus: "Loading...")
            self.cities = cities
            indicator.dismiss()
        }
    }
    
    @objc
    func handleSaveButton() {
        if let surname = lastName.text, let name = firstName.text, let middleName = patronymic.text, let cityID = cityID, let token = UserDefaults.standard.string(forKey: "token") {
            let body : [String: String] = [
                "token" : token,
                "surname" : surname,
                "name" : name,
                "middle_name" : middleName,
                "city_id" : "\(cityID)"
            ]
            
            indicator.show(withStatus: "Updating data...")
            Alamofire.upload(
                multipartFormData: { multipartFormData in

                    if let profileImage = self.selectedImage {
                        if let profileImageData = UIImageJPEGRepresentation(profileImage, 0.7) {
                            let imageRandomName = NSUUID().uuidString
                            multipartFormData.append(profileImageData, withName: "avatar", fileName: "\(imageRandomName).jpeg", mimeType: "image/jpeg")
                        }
                    }
                    for (key, value) in body {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
                to: Constant.api.edit_profile, method: .post,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            print("Response profile edit: \(response)")
                            if response.result.isSuccess {
                                if let value = response.result.value {
                                    let json = JSON(value)

                                    print("Edit profile: \(json)")

                                    if json["statusCode "].intValue == Constant.statusCode.success {
                                        indicator.dismiss()
                                        indicator.showSuccess(withStatus: "Data is updated")
                                        indicator.dismiss(withDelay: 1.5)

                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.setupAppdelegate()
                                        }
                                    } else {
                                        indicator.showError(withStatus: .localizedString(key: "fill_all"))
                                        indicator.dismiss(withDelay: 2)
                                    }
                                }
                            } else {
                                if let error = response.result.error {
                                    indicator.dismiss()
                                    indicator.showError(withStatus: "Not OK")
                                    indicator.dismiss(withDelay: 3)
                                    print("Encoding result: \(encodingResult)")
                                    print(error.localizedDescription)
                                    if error.localizedDescription == "The Internet connection appears to be offline." { }
                                    else { }
                                }
                            }
                        }
                    case .failure(let encodingError):

                        print(encodingError.localizedDescription)
                    }
            })
        } else {
            let alertViewController = UIAlertController(title: .localizedString(key: "error"), message: .localizedString(key: "fields"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertViewController.addAction(okAction)
            
            present(alertViewController, animated: true, completion: nil)
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
        city.text = cities[row].name
        cityID = cities[row].id
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Picked")
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImage = editedImage
            profileImage.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = originalImage
            profileImage.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
