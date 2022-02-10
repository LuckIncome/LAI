//
//  NotificationDetailsViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationDetailsViewController : UITableViewController {
    
    let cellID = "notifDetailCellID"
    var notification : Notification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(NotificationDetailCell.self, forCellReuseIdentifier: cellID)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 750
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! NotificationDetailCell
        
        cell.title.text = notification?.title
        if let photo = notification?.image {
            let url = URL(string: photo)
            cell.contentImageView.kf.setImage(with: url)
        }
        cell.content.text = notification?.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
