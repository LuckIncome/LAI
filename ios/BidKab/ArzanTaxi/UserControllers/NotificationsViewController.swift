//
//  NotificationsViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import FirebaseMessaging

class NotificationsViewController : RefreshController {
    let cellID = "notifCellID"
    var list = [Notification]()
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
        setNavigationBarTransparent(title: String.localizedString(key: "notifications"), shadowImage: true)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        navigationItem.title = String.localizedString(key: "notifications")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        tableView.addSubview(refresh)
        tableView.backgroundColor = .white
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 70
        tableView.tableFooterView = UIView()
        
        loadNotifications()
    }
    
    override func refreshData(_ sender: UIRefreshControl) {
        list.removeAll()
        tableView.reloadData()
        loadNotifications()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NotificationCell
        
        cell.title.text = list[indexPath.row].title
        cell.date.text = list[indexPath.row].updated_at
        cell.content.text = list[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationDetailViewController = NotificationDetailsViewController()
        
        notificationDetailViewController.notification = list[indexPath.row]
        
        navigationController?.pushViewController(notificationDetailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
}
