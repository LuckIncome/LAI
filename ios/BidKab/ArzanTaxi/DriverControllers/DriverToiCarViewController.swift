//
//  DriverToiCarViewController.swift
//  ArzanTaxi
//
//  Created by Mukhamedali Tolegen on 24.02.18.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DriverToiCarViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "toiCellID"
    
    var user : User?
    
    let addButtonView : UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var addButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle(.localizedString(key: "add_toi"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    let refresh = UIRefreshControl()
    
    func setupViews() {
        view.addSubview(addButtonView)
        addButtonView.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(70)
        }
        
        addButtonView.addSubview(addButton)
        addButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(45)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(addButtonView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresh
        } else {
            tableView.addSubview(refresh)
        }
        
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        if let phone = user?.phone {
            let body : Parameters = [ "phone" : phone ]
            User.authUser(body: body, completion: { (result, user, statusCode) in
                switch result{
                case .success:
                    self.user = user
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                break
                case .failure:
                    print("Error auth")
                break
                }
            })
        }
    }
    
    @objc func handleButton() {
        let viewController = AddToiViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(SpecialViewCell.self, forCellReuseIdentifier: cellID)
        setupViews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let toiCars = user?.toi_cars {
            return toiCars.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SpecialViewCell
        
        if let toiCars = user?.toi_cars {
            if let carMark = toiCars[indexPath.row].car_mark, let carModel = toiCars[indexPath.row].car_model {
                cell.textLabel?.text = "\(carMark) \(carModel)"
                cell.detailTextLabel?.text = toiCars[indexPath.row].price
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
