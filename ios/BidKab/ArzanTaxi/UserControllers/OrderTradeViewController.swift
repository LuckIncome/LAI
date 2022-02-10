//
//  OrderTradeViewController.swift
//  ArzanTaxi
//
//  Created by Nursultan on 08.12.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import GoogleMaps

class OrderTradeViewController: UIViewController {

    var block: (()->())?
    var orderAcceptedBlock: (()->())?
    var drivers: [User] = []
    var index: Int?
    var delegate: Orderable?
    var timerForProgressView: [Timer] = []
    var currentTime: Int = 0
    var location: CLLocation?
    

    private let cellIdentifier = "orderTradeCell"

    let pointAimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointa"))
    let pointBimageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "pointb"))
    let priceImageView = Helper.setupOrderViewImage(with: #imageLiteral(resourceName: "price"))
    
    let pointBunderline = Helper.setupUnderline()
    let pointAunderline = Helper.setupUnderline()
    let priceUnderline = Helper.setupUnderline()
    
    let priceTextField : UILabel = {
        let textField = UILabel()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.text = "Price"

        return textField
    }()
    
    lazy var aPointSearchButton : UILabel = {
        let textField = UILabel()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.text = "Apoint"
        
        return textField
    }()
    
    lazy var bPointSearchButton : UILabel = {
        let textField = UILabel()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .blue
        textField.text = "Bpoint"

        return textField
    }()


    lazy var orderView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        return backView
    }()

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(.localizedString(key: "cancel_order"), for: .normal)
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)

        return cancelButton
    }()

    lazy var messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.textColor = .white
        messageLabel.font = UIFont.systemFont(ofSize: 20)
        messageLabel.text = "Please, accept or cancel orders."
        messageLabel.numberOfLines = 2

        return messageLabel
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderTradeTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear

        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getOrderTrade()
        getOrderInfo()
        order()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        Socket.shared.client.off("order_trade")
    }

    func checkProgressView(driverId: Int){
        drivers.removeAll(where: {$0.id == driverId})
        tableView.reloadData()
    }

    @objc func cancelButtonPressed(){
        self.dismiss(animated: true, completion: {
            if let block = self.block {
                block()
            }
        })
    }

    @objc func orderTradeCancelPressed(sender: UIButton){
        UIView.animate(withDuration: 0.5) {
            self.orderView.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
            
        }
        
        let index = sender.tag
        
        if !drivers.isEmpty {
            drivers.remove(at: index)
        }
        
        tableView.reloadData()
    }

    @objc func orderTradeAcceptPressed(sender: UIButton){
        let index = sender.tag
        Socket.shared.acceptOrderTrade(order_id: drivers[index].orderId!, driver_id: drivers[index].id!, price: Int(drivers[index].price!)!) { (isSuccess) in
            if isSuccess {
                self.index = index
                self.timerForProgressView.forEach({$0.invalidate()})
                self.dismiss(animated: true, completion: {
                    if let block = self.orderAcceptedBlock {
                        print("OrderAcceptedBlock")
                        self.delegate?.getOrderInformation(order: self.drivers[index])
                        block()
                    }
                })
            } else {
                print("Not accepted")
            }
        }
    }
    
    private func getDistance(index: Int) -> String {

        guard let latitude = drivers[index].lat else {return "0 km"}
        guard let longitude = drivers[index].lon else {return "0 km"}
        guard let location = location else {return "0 km"}

        let driverLocation = CLLocation(latitude: Double(latitude)!, longitude: Double(longitude)!)
        var distance = location.distance(from: driverLocation)
        distance = round(10*distance/1000)/10

        return "\(distance) km"
    }

    private func getOrderTrade(){
        guard let orderId = UserDefaults.standard.value(forKey: "currentOrderID") as? Int else {return}
        
        Socket.shared.getOrderTrade(orderId: orderId) { drivers in
            print("Get order trade: \(drivers.count)")
            UIView.animate(withDuration: 0.5, animations: {
                self.orderView.frame.origin.y = self.view.frame.height
            })
            self.drivers = drivers
            self.tableView.reloadData()
        }
    }
    
    private func getOrderInfo() -> Void {
        self.aPointSearchButton.text = UserDefaults.standard.string(forKey: "fromL")
        self.bPointSearchButton.text = UserDefaults.standard.string(forKey: "toL")
        self.priceTextField.text = UserDefaults.standard.string(forKey: "priceL")

    }

    private func order(){
        Socket.shared.order { (id, step, carMark, carModel, carColor, carNumber, name, driverPhone, surname, middleName, rating, avatar, driverID, driverLat, driverLon) in
            if step == 2 {
                self.dismiss(animated: true, completion: {
                    if let block = self.orderAcceptedBlock {
                        block()
                    }
                })
            }
        }
    }

    private func setupViews(){

        view.addSubview(backView)
        view.addSubview(tableView)
        view.addSubview(orderView)
        orderView.addSubview(pointAimageView)
        orderView.addSubview(pointBimageView)
        orderView.addSubview(priceImageView)
        orderView.addSubview(aPointSearchButton)
        orderView.addSubview(pointAunderline)
        orderView.addSubview(bPointSearchButton)
        orderView.addSubview(pointBunderline)
        orderView.addSubview(priceTextField)
        orderView.addSubview(priceUnderline)
        orderView.addSubview(cancelButton)

        let orderViewImageViewWidth = 20
        let orderViewImageViewHeight = 30

        tableView.snp.makeConstraints { (tableView) in
            tableView.left.right.equalTo(view)
            tableView.top.equalToSuperview().offset(50)
            tableView.bottom.equalTo(view).offset(-10)
        }
        

        backView.snp.makeConstraints { (backView) in
            backView.width.height.centerX.centerY.equalTo(view)
        }
        
        orderView.frame = CGRect(x: 0, y: view.frame.height - 200, width: view.frame.width, height: 200)
        orderView.round(corners: [.topLeft, .topRight], radius: 30)
        orderView.shadow(opacity: 0.8, radius: 2)
        
        pointAimageView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(20)
            make.width.equalTo(orderViewImageViewWidth)
            make.height.equalTo(orderViewImageViewHeight)
        }
        
        pointBimageView.snp.makeConstraints { (make) in
            make.top.equalTo(pointAimageView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalTo(orderViewImageViewWidth)
            make.height.equalTo(orderViewImageViewHeight)
        }

        priceImageView.snp.makeConstraints { (make) in
            make.top.equalTo(pointBimageView.snp.bottom).offset(15)
            make.left.equalTo(20)
            make.width.equalTo(orderViewImageViewWidth)
            make.height.equalTo(orderViewImageViewHeight)
        }
        
        aPointSearchButton.snp.makeConstraints { (make) in
            make.top.equalTo(pointAimageView)
            make.left.equalTo(pointAimageView.snp.right).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(pointAimageView)
        }
        
        bPointSearchButton.snp.makeConstraints { (make) in
            make.top.equalTo(pointBimageView)
            make.left.equalTo(pointBimageView.snp.right).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(pointBimageView)
        }
        
        priceTextField.snp.makeConstraints { (make) in
            make.top.equalTo(priceImageView)
            make.left.equalTo(priceImageView.snp.right).offset(15)
            make.right.equalTo(-20)
            make.height.equalTo(priceImageView)
        }

        pointAunderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(aPointSearchButton).offset(10)
            make.height.equalTo(1)
        }
        
        pointBunderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bPointSearchButton).offset(10)
            make.height.equalTo(1)
        }
        
        priceUnderline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(priceTextField).offset(10)
            make.height.equalTo(1)
        }

        cancelButton.snp.makeConstraints { (cancelButton) in
            cancelButton.centerX.equalToSuperview()
            cancelButton.bottom.equalToSuperview().offset(-20)
        }

//        view.addSubview(messageLabel)
//        messageLabel.snp.makeConstraints { (messageLabel) in
//            messageLabel.top.equalTo(cancelButton.snp.bottom).offset(20)
//            messageLabel.left.equalTo(view).offset(20)
//            messageLabel.right.equalTo(view).offset(-20)
//        }
    }

}

extension OrderTradeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drivers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderTradeTableViewCell
        let url = URL(string: Constant.api.prefixForImage + drivers[indexPath.row].avatar!)
        cell.driverCarLabel.text = drivers[indexPath.row].taxi_cars?.mark?.name
        cell.driverFullNameLabel.text = "\(drivers[indexPath.row].name!) \(drivers[indexPath.row].surname!)"
        cell.driverImageView.kf.setImage(with: url, placeholder: UIImage(named: "profile_image"), options: nil, progressBlock: nil, completionHandler: nil)
        cell.priceOfOrderLabel.text = drivers[indexPath.row].price! + "₸"
        cell.ratingLabel.text = drivers[indexPath.row].rating
        cell.isTimerStarted = true
        cell.driverId = drivers[indexPath.row].id
        cell.block = { [weak self] driverId in
            guard let `self` = self else {return}
            self.checkProgressView(driverId: driverId)
        }

        cell.distanceLabel.text = getDistance(index: indexPath.row)

        cell.acceptButton.addTarget(self, action: #selector(orderTradeAcceptPressed(sender:)), for: .touchUpInside)
        cell.cancelButton.addTarget(self, action: #selector(orderTradeCancelPressed(sender:)), for: .touchUpInside)
        cell.acceptButton.tag = indexPath.row
        cell.cancelButton.tag = indexPath.row
        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }


}
