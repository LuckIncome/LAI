//
//  VipTaxiViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class VipTaxiViewController : UITableViewController {
    
    let cellID = "vipTaxiCellID"
    var list = [VipTaxi]()
    var navTitle : String?
    
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
        
        navigationItem.title = String.localizedString(key: "toi_taxi")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        tableView.register(VipTaxiCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .gray
        tableView.tableFooterView = UIView()
        
        loadVipTaxi()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! VipTaxiCell
        
        cell.textLabel?.text = list[indexPath.row].name
        cell.detailTextLabel?.text = list[indexPath.row].car_mark! + " " + list[indexPath.row].car_model!
        cell.descriptionLabel.text = list[indexPath.row].price
        if let phone = list[indexPath.row].phone {
            cell.phone = phone.removingWhitespaces()
        }
        
        if let photo = list[indexPath.row].imageURLs?.first {
            let url = URL(string: photo)
            cell.profileImage.kf.setImage(with: url)
        }
        
        return cell
    }
}
