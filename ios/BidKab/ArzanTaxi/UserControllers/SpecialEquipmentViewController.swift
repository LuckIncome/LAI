//
//  SpecialEquipmentViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/14/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Kingfisher

class SpecialEquipmentViewController : UITableViewController {
    
    let cellID = "specEquipCellID"
    var specialEquipments = [SpecialEquipment]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = .localizedString(key: "special_eqipment")
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
        
        tableView.allowsSelection = false
        
        SpecialEquipment.getSpecialEquipment { (specialEquipments) in
            self.specialEquipments = specialEquipments
            self.tableView.reloadData()
        }

        if let revealController = revealViewController() {
            navigationController?.navigationBar.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        tableView.register(SpecialEquipmentCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .gray
        tableView.tableFooterView = UIView()
        
        view.backgroundColor = .white
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SpecialEquipmentCell
        
        if let name = specialEquipments[indexPath.row].name, let type = specialEquipments[indexPath.row].info, let text = specialEquipments[indexPath.row].text, let phone = specialEquipments[indexPath.row].phone {
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = type
            cell.descriptionLabel.text = text
            cell.phoneNumber = phone
            
            if let photo = specialEquipments[indexPath.row].images?.first {
                let url = URL(string: photo)
                cell.profileImage.kf.setImage(with: url)
            }
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialEquipments.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
