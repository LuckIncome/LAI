//
//  DriverIntercityListCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverIntercityListCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    let cellID = "driverIntercityCellID"
    var list = [Intercity]()
    //var delegate : DriverIntercityControllerDelegate?
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
//        tableView.allowsSelection = false
        
        return tableView
    }()
    
    let refresh = UIRefreshControl()
    
    func setupViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        refresh.addTarget(self, action: #selector(getAllIntercityList), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getAllIntercityList()
        setupViews()
        tableView.register(DriverIntercityCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverIntercityCell
        
        cell.date.text = list[indexPath.row].date
        cell.aPoint.text = list[indexPath.row].from
        cell.bPoint.text = list[indexPath.row].to
        cell.price.text = "\(list[indexPath.row].price!)"
        cell.phone = list[indexPath.row].passenger!.phone!
        cell.phoneButton.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Accept order?", message: "Press the button to accept.", preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default) { (action) in
            if let id = self.list[indexPath.row].id {
                //self.delegate?.acceptIntercityOrder(id: id)
            }
        }
        let discardButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(acceptButton)
        alert.addAction(discardButton)
        
       // delegate?.showAlert(alert: alert)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
