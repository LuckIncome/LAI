//
//  MyAutoCell.swift
//  ArzanTaxi
//
//  Created by MAC on 15.07.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import SnapKit

class MyAutoCell: UITableViewCell {

    var delegate : HistoryViewControllerDelegate?
    
    var date = Helper.createOrderLabel(image: #imageLiteral(resourceName: "calendar"), text: "")
    var price = Helper.createOrderLabel(image: #imageLiteral(resourceName: "tenge"), text: "")
    
    var from : String?
    var to : String?
    var fromLat : Double?
    var fromLon : Double?
    var toLat : Double?
    var toLon : Double?
    var priceValue : Int?
    var getPassenger : Int?
    var passengersCount : Int?
    var bonus : Int?
    var desc : String?
    
    lazy var optionButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "option"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
        
        return button
    }()
    
    @objc
    func handleOptionButton() {
        if let from = from, let to = to, let fromLat = fromLat, let fromLon = fromLon, let toLat = toLat, let toLon = toLon, let priceValue = priceValue, let getPassenger = getPassenger, let passengersCount = passengersCount, let bonus = bonus, let description = desc {
            delegate?.optionButton(from: from, to: to, price: priceValue, fromLat: fromLat, fromLon: fromLon, toLat: toLat, toLon: toLon, getPassenger: getPassenger, passengersCount: passengersCount, bonus: bonus, description: description, cityId: 1)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(date)
        addSubview(price)
        addSubview(optionButton)
        
        date.topAnchor.constraint(equalTo: topAnchor).isActive = true
        date.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        date.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        date.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        price.topAnchor.constraint(equalTo: date.bottomAnchor).isActive = true
        price.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        price.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        price.heightAnchor.constraint(equalToConstant: 27.5).isActive = true
        
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        optionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        optionButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        optionButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
