//
//  ContactUsController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 8/15/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactUsController: UIViewController {
    var message = ""
    var images: [Data] = []

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
        setNavigationBarTransparent(title: .localizedString(key: "contactUs"), shadowImage: false)
//        navigationItem.title = String.localizedString(key: "contactUs")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationController?.navigationBar.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        setupViews()
    }
    
    @objc func sendMessage(_ sender: UIButton) {
        message = messageTextView.text
        guard message != "" else {
            indicator.showError(withStatus: String.localizedString(key: "fields"))
            return }
        let token = UserDefaults.standard.string(forKey: "token")!
        let parameters: [String: Any] = [
            "token": token,
            "text": message
        ]
        let url = Constant.api.sendMessage
        indicator.show()
        Alamofire.upload(multipartFormData: { (multipartData) in
            for (key, value) in parameters {
                multipartData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            for data in self.images {
                multipartData.append(data, withName: "images[]", fileName: UUID().uuidString + ".jpg", mimeType: "image/jpg")
            }
        }, usingThreshold: UInt64(), to: url, method: HTTPMethod.post, headers: ["Content-Type": "application/x-www-form-urlencoded"], encodingCompletion: { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if response.result.isSuccess {
                        if let value = response.result.value {
                            let json = JSON(value)
                            print("Send message: \(json)")
                            if json["statusCode "].intValue == Constant.statusCode.success {
                                indicator.showSuccess(withStatus: .localizedString(key: "success"))
                                self.messageTextView.text = ""
                            } else {
                                indicator.showError(withStatus: .localizedString(key: "error"))
                            }
                        }
                    }
                })
            }
        })
    }
    
//    @objc func pickImage(_ sender: UIButton) {
//        let pickerVC = UIImagePickerController()
//        pickerVC.delegate = self
//        pickerVC.view.tag = sender.tag
//        pickerVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        present(pickerVC, animated: true, completion: nil)
//    }
    
    private func setupViews() {
        view.backgroundColor = .paleGray
        view.addSubview(titleLabel)
        view.addSubview(messageTextView)
//        view.addSubview(firstPhotoButton)
//        view.addSubview(secondPhotoButton)
        view.addSubview(sendButton)
        view.addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
        }

//        firstPhotoButton.snp.makeConstraints { (make) in
//            make.top.equalTo(messageTextView.snp.bottom).offset(20)
//            make.right.equalTo(view.snp.centerX).offset(-10)
//            make.width.height.equalTo(50)
//        }
//
//        secondPhotoButton.snp.makeConstraints { (make) in
//            make.top.equalTo(firstPhotoButton.snp.top)
//            make.left.equalTo(view.snp.centerX).offset(10)
//            make.width.height.equalTo(50)
//        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(UIViewController.heightNavBar + 60)
            make.bottom.equalTo(placeholderLabel.snp.top).offset(-100)
            make.left.right.equalToSuperview()
        }
        
        messageTextView.snp.makeConstraints { (make) in
            make.height.equalTo(150)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.center.equalTo(placeholderLabel)
            
        }
        
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(messageTextView.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "complaint")
        label.textAlignment = .center
        label.textColor = .blue
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = .localizedString(key: "desc")
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()


    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 18
        tv.layer.borderColor = UIColor.blue.cgColor
        tv.textColor = .black
        tv.backgroundColor = .paleGray
        tv.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return tv
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(String.localizedString(key: "send"), for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        return button
    }()
//
//    lazy var firstPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "nav_bar_plus"), for: .normal)
//        button.tag = 1
//        button.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
//
//        return button
//    }()
//
//    lazy var secondPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "nav_bar_plus"), for: .normal)
//        button.tag = 2
//        button.addTarget(self, action: #selector(pickImage(_:)), for: .touchUpInside)
//
//        return button
//    }()
}

extension ContactUsController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        message = textView.text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.text.isEmpty ? (placeholderLabel.isHidden = false) : (placeholderLabel.isHidden = true)
    }
}

//extension ContactUsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let selectedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
//        guard let image = selectedImage else { return }
//        let button: UIButton = picker.view.tag == 1 ? firstPhotoButton : secondPhotoButton
//        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
//        let imageData = UIImagePNGRepresentation(image)!
////        images[picker.view.tag - 1] = imageData
//
//        let index = picker.view.tag - 1
//        if images.indices.contains(index) {
//            images[index] = imageData
//        } else {
//            images.append(imageData)
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//}
