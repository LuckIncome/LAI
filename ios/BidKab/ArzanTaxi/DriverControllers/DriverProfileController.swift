//
//  DriverProfileController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/21/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class DriverProfileController : UIViewController, DriverProfileControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "profileCellID"
    var user : User?
    var tag : Int?
    var idCardImage : UIImage?
    var idCardImage2 : UIImage?
    var techPassportImage : UIImage?
    var techPassportImage2 : UIImage?
    var pravaImage : UIImage?
    var pravaImage2 : UIImage?
    var carImage : UIImage?
    var carImage2 : UIImage?
    var profileImage : UIImage?
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
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

//        view.backgroundColor = .white
//
//        langImage = langImage.withRenderingMode(.alwaysOriginal)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: langImage, style: .plain, target: self, action: #selector(changeLanguage))

        navigationItem.title = String.localizedString(key: "edit_profile")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func pickImage(tag : Int) {
        self.tag = tag
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            let indexPath = IndexPath(item: 0, section: 0)
            let cell : ProfileCell = tableView.cellForRow(at: indexPath) as! ProfileCell
            if let senderTag = self.tag {
                switch senderTag {
                    case 0:
                        cell.profileImage.image = selectedImage
                        profileImage = selectedImage
                    case 1:
                        cell.idCardImageView.image = selectedImage
                        idCardImage = selectedImage
                        cell.idCardImageLabel.isHidden = true
                    case 2:
                        cell.idCardImageView2.image = selectedImage
                        idCardImage2 = selectedImage
                        cell.idCardImageLabel2.isHidden = true
                    case 3:
                        cell.techPassportImageView.image = selectedImage
                        techPassportImage = selectedImage
                        cell.techPassportImageLabel.isHidden = true
                    case 4:
                        cell.techPassportImageView2.image = selectedImage
                        techPassportImage2 = selectedImage
                        cell.techPassportImageLabel2.isHidden = true
                    case 5:
                        cell.pravaImageView.image = selectedImage
                        pravaImage = selectedImage
                        cell.pravaImageLabel.isHidden = true
                    case 6:
                        cell.pravaImageView2.image = selectedImage
                        pravaImage2 = selectedImage
                        cell.pravaImageLabel2.isHidden = true
                    case 7:
                        cell.carImageView.image = selectedImage
                        carImage = selectedImage
                        cell.carImageLabel.isHidden = true
                    case 8:
                        cell.carImageView2.image = selectedImage
                        carImage2 = selectedImage
                        cell.carImageLabel2.isHidden = true
                    default:
                        return
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if let senderTag = self.tag {
            let indexPath = IndexPath(item: 0, section: 0)
            let cell : ProfileCell = tableView.cellForRow(at: indexPath) as! ProfileCell
            
            switch senderTag {
                case 1:
                    if cell.idCardImageView.image == nil {
                        cell.idCardImageLabel.isHidden = false
                    }
                case 2:
                    if cell.idCardImageView2.image == nil {
                        cell.idCardImageLabel2.isHidden = false
                    }
                case 3:
                    if cell.techPassportImageView.image == nil {
                        cell.techPassportImageLabel.isHidden = false
                    }
                case 4:
                    if cell.techPassportImageView2.image == nil {
                        cell.techPassportImageLabel2.isHidden = false
                    }
                case 5:
                    if cell.pravaImageView.image == nil {
                        cell.pravaImageLabel.isHidden = false
                    }
                case 6:
                    if cell.pravaImageView2.image == nil {
                        cell.pravaImageLabel2.isHidden = false
                    }
                case 7:
                    if cell.carImageView.image == nil {
                        cell.carImageLabel2.isHidden = false
                    }
                case 8:
                    if cell.carImageView.image == nil {
                        cell.carImageLabel2.isHidden = false
                    }
                default:
                    break
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! ProfileCell
        cell.delegate = self
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
}
