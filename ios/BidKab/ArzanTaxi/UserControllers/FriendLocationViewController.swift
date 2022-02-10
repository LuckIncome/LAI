//
//  FriendLocationViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/13/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FriendLocationViewController : UITableViewController {
    
    let cellID = "freindCellID"
    var friends = [User]()
    var navTitle : String?
    
    let refresh = UIRefreshControl()
    
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
        
        navigationItem.title = String.localizedString(key: "find_friends")
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_bar_plus"), style: .plain, target: self, action: #selector(handleAddFriend))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        tableView.register(FriendCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        
        refresh.addTarget(self, action: #selector(getAllFriends), for: .valueChanged)
        
        tableView.addSubview(refresh)
        
        getAllFriends()
    }
    
    @objc func handleAddFriend() {
        navigationController?.pushViewController(AddFriendViewController(), animated: true)
    }
    
    @objc func deleteAction(_ sender: UIButton) {
        let index = sender.tag - 1
        let friendId = friends[index].id!
        let token = UserDefaults.standard.string(forKey: "token")!
        
        let body : Parameters = [
            "token" : token,
            "user_id" : "\(friendId)"
        ]
        
        Alamofire.request(Constant.api.friend_delete, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    self.friends.remove(at: index)
                    self.tableView.reloadData()
                    let json = JSON(value)
                    print("Friend delete: \(json)")
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FriendCell
        cell.deleteButton.tag = indexPath.row + 1
        cell.deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        if let surname = friends[indexPath.row].surname, let name = friends[indexPath.row].name {
            cell.textLabel?.text = surname + " " + name
            cell.detailTextLabel?.text = friends[indexPath.row].phone
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let friend = friends[indexPath.row]
        let locationOfFriend = LocationOfFriendViewController(friend: friend)
        navigationController?.pushViewController(locationOfFriend, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
