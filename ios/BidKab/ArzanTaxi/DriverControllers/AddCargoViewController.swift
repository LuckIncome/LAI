//
//  AddCargoViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 2/16/18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker
import Alamofire
import SwiftyJSON
import SVProgressHUD

class AddCargoViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let car = Helper.createInputField(withPlaceholder: "Mark and model of cargo", errorText: "")
    let additional = Helper.createInputField(withPlaceholder: "Additional", errorText: "")
    
    var images = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    lazy var addImageButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Add an image", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleImageButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        
        return button
    }()
    
    func setupViews() {
        view.addSubview(car)
        car.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(additional)
        additional.snp.makeConstraints { (make) in
            make.top.equalTo(car.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
        }
        
        view.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(additional.snp.bottom).offset(30)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.top.equalTo(addImageButton.snp.bottom).offset(15)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }
    
    @objc func handleImageButton() {
        let imagePicker = BSImagePickerViewController()
        imagePicker.maxNumberOfSelections = 4
        bs_presentImagePickerController(imagePicker, animated: true,
                                        select: { (asset : PHAsset) in
                                            
                                        },
                                        deselect: { (asset : PHAsset) in
                                            
                                        },
                                        cancel: { (assets : [PHAsset]) in
            
                                        },
                                        finish: { (assets : [PHAsset]) in
                                            for i in assets {
                                                self.selectedAssets.append(i)
                                            }
                                            DispatchQueue.main.async {
                                                self.addImageButton.setTitle("Selected an image (\(assets.count))", for: .normal)
                                            }
                                            self.convertAssetsToImages()
                                        },
                                        completion: nil)
    }
    
    func convertAssetsToImages() {
        if selectedAssets.count != 0 {
            for i in selectedAssets {
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                var image = UIImage()
                option.isSynchronous = true
                manager.requestImage(for: i, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: { (result, info) in
                    if let result = result {
                        image = result
                    }
                })
                
                if let data = UIImageJPEGRepresentation(image, 0.7) {
                    if let compressedImage = UIImage(data: data) {
                        images.append(compressedImage)
                    }
                }
            }
        }
    }
    
    @objc func handleAddButton() {
        if let info = car.text, let text = additional.text, let token = UserDefaults.standard.string(forKey: "token") {
            let body : [String: String] = [
                "info" : info,
                "text" : text,
                "token" : token
            ]
         
            let indicator = SVProgressHUD.self
            indicator.show(withStatus: "Loading...")
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for image in self.images {
                        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                            let imageRandomName = NSUUID().uuidString
                            multipartFormData.append(imageData, withName: "images[]", fileName: "\(imageRandomName).jpg", mimeType: "image/jpeg")
                        }
                    }
                    
                    for (key, value) in body {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
            },
                to: Constant.api.add_cargo, method: .post,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            if response.result.isSuccess {
                                indicator.dismiss()
                                indicator.showSuccess(withStatus: "Success")
                                indicator.dismiss(withDelay: 3)
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    
                                    print("Add cargo: \(json)")
                                    
                                    if json["statusCode "].intValue == Constant.statusCode.success {
                                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                            appDelegate.setupAppdelegate()
                                        }
                                    }
                                }
                            } else {
                                if let error = response.result.error {
                                    indicator.dismiss()
                                    indicator.showError(withStatus: "Not OK")
                                    indicator.dismiss(withDelay: 3)
                                    print("Encoding result cargo: \(encodingResult)")
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
            
        }
    }
}
