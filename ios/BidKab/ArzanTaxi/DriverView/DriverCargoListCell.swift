//
//  DriverCargoListCell.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 12/18/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit

class DriverCargoListCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    let cellID = "driverCargoCellID"
    var list = [Cargo]()
    var delegate : DriverCargoControllerDelegate?
    
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    let refresh = UIRefreshControl()
    
    func setupViews() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        refresh.addTarget(self, action: #selector(getAllCargoList), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getAllCargoList()
        setupViews()
        tableView.register(DriverCargoCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! DriverCargoCell
        
        cell.aPoint.text = list[indexPath.row].from
        cell.bPoint.text = list[indexPath.row].to
        cell.price.text = "\(list[indexPath.row].price!) тг"
        
        if list[indexPath.row].document == 1 {
            cell.document.text = .localizedString(key: "doc_yes")
        } else {
            cell.document.text = .localizedString(key: "doc_no")
        }
        
        if list[indexPath.row].bargain == 1 {
            cell.torg.text = .localizedString(key: "torg_yes")
        } else {
            cell.torg.text = .localizedString(key: "torg_no")
        }
        
        cell.phone = list[indexPath.row].passenger!.phone!
        cell.phoneButton.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Accept order?", message: "Press the button to accept.", preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default) { (action) in
            if let id = self.list[indexPath.row].id {
                //self.delegate?.acceptCargoOrder(id: id)
            }
        }
        let discardButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(acceptButton)
        alert.addAction(discardButton)
        
        //delegate?.showAlert(alert: alert)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
