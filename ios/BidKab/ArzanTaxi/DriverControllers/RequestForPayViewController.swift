//
//  RequestForPayView.swift
//  BidKab
//
//  Created by Rustem Madigassymov on 18.08.2021.
//  Copyright © 2021 Nursultan Zhiyembay. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import Firebase

class RequestForPayViewController: UIViewController {
    
    //MARK: - Properties
    private var selectedType: Int = 0
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    private lazy var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Тарифы"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    private lazy var descLabel: UILabel = {
        let label = UILabel()
        label.text = "Выберите более подходящий для вас тариф"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close-black"), for: .normal)
        button.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        return button
    }()
    private lazy var firstRateButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        let attrs1 = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrString1 = NSMutableAttributedString(string: "4\n", attributes: attrs1)
        let attrString2 = NSMutableAttributedString(string: "Часов".uppercased(), attributes: attrs2)
        attrString1.append(attrString2)
        button.setAttributedTitle(attrString1, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(tapRate(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var secondRateButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        let attrs1 = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrString1 = NSMutableAttributedString(string: "8\n", attributes: attrs1)
        let attrString2 = NSMutableAttributedString(string: "Часов".uppercased(), attributes: attrs2)
        attrString1.append(attrString2)
        button.setAttributedTitle(attrString1, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(tapRate(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var thirdRateButton: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        let attrs1 = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 24),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key: Any]
        let attrString1 = NSMutableAttributedString(string: "12\n", attributes: attrs1)
        let attrString2 = NSMutableAttributedString(string: "Часов".uppercased(), attributes: attrs2)
        attrString1.append(attrString2)
        button.setAttributedTitle(attrString1, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.addTarget(self, action: #selector(tapRate(sender:)), for: .touchUpInside)
        return button
    }()
    private lazy var popularView: UIButton = {
        let view = UIButton()
        view.setTitle("Популярный".uppercased(), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 8)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 8.5
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var gainfulView: UIButton = {
        let view = UIButton()
        view.setTitle("Выгодный".uppercased(), for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 8)
        view.backgroundColor = .yellow
        view.layer.cornerRadius = 8.5
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var chosenHoursLabel: UILabel = {
        let label = UILabel()
        label.text = "12"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    private lazy var hoursLabel: UILabel = {
        let label = UILabel()
        label.text = " часов"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var vertLine = UIView()
    private lazy var chosenPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "8 500 ₸"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 28)
        return label
    }()
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать за 4 500₸", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapDone), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tapRate(sender: thirdRateButton)
    }
    
    //MARK: - Setup views
    private func setupViews() {
        vertLine.backgroundColor = .gray
        
        view.addSubview(shadowView)
        view.addSubview(mainView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(descLabel)
        mainView.addSubview(closeButton)
        mainView.addSubview(firstRateButton)
        mainView.addSubview(secondRateButton)
        mainView.addSubview(thirdRateButton)
        mainView.addSubview(popularView)
        mainView.addSubview(gainfulView)
        mainView.addSubview(chosenHoursLabel)
        mainView.addSubview(hoursLabel)
        mainView.addSubview(vertLine)
        mainView.addSubview(chosenPriceLabel)
        mainView.addSubview(chooseButton)
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        mainView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(337)
            make.height.equalTo(303)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(14)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        firstRateButton.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(91)
            make.height.equalTo(69)
        }
        secondRateButton.snp.makeConstraints { make in
            make.top.equalTo(firstRateButton)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(firstRateButton)
        }
        thirdRateButton.snp.makeConstraints { make in
            make.top.equalTo(firstRateButton)
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(firstRateButton)
        }
        popularView.snp.makeConstraints { make in
            make.centerX.equalTo(secondRateButton)
            make.centerY.equalTo(secondRateButton.snp.bottom)
            make.width.equalTo(72)
            make.height.equalTo(17)
        }
        gainfulView.snp.makeConstraints { make in
            make.centerX.equalTo(thirdRateButton)
            make.centerY.equalTo(thirdRateButton.snp.bottom)
            make.width.equalTo(62)
            make.height.equalTo(17)
        }
        vertLine.snp.makeConstraints { make in
            make.top.equalTo(secondRateButton.snp.bottom).offset(35)
            make.centerX.equalToSuperview().offset(-8)
            make.width.equalTo(0.5)
            make.height.equalTo(28)
        }
        hoursLabel.snp.makeConstraints { make in
            make.right.equalTo(vertLine).offset(-16)
            make.bottom.equalTo(vertLine)
        }
        chosenHoursLabel.snp.makeConstraints { make in
            make.right.equalTo(hoursLabel.snp.left).offset(-8)
            make.bottom.equalTo(vertLine).offset(4)
        }
        chosenPriceLabel.snp.makeConstraints { make in
            make.left.equalTo(vertLine).offset(16)
            make.bottom.equalTo(vertLine).offset(4)
        }
        chooseButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(238)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    
    //MARK: - Objc functions
    @objc private func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func tapRate(sender: UIButton) {
        selectedType = sender.tag
        switch sender.tag {
        case 1:
            firstRateButton.layer.borderWidth = 2
            firstRateButton.layer.borderColor = UIColor.blue.cgColor
            secondRateButton.layer.borderWidth = 1
            secondRateButton.layer.borderColor = UIColor.lightGray.cgColor
            thirdRateButton.layer.borderWidth = 1
            thirdRateButton.layer.borderColor = UIColor.lightGray.cgColor
            chosenHoursLabel.text = "4"
            chosenPriceLabel.text = "2 500 ₸"
            chooseButton.setTitle("Выбрать за 2 500 ₸", for: .normal)
        case 2:
            firstRateButton.layer.borderWidth = 1
            firstRateButton.layer.borderColor = UIColor.lightGray.cgColor
            secondRateButton.layer.borderWidth = 2
            secondRateButton.layer.borderColor = UIColor.blue.cgColor
            thirdRateButton.layer.borderWidth = 1
            thirdRateButton.layer.borderColor = UIColor.lightGray.cgColor
            chosenHoursLabel.text = "8"
            chosenPriceLabel.text = "4 500 ₸"
            chooseButton.setTitle("Выбрать за 4 500 ₸", for: .normal)
        case 3:
            firstRateButton.layer.borderWidth = 1
            firstRateButton.layer.borderColor = UIColor.lightGray.cgColor
            secondRateButton.layer.borderWidth = 1
            secondRateButton.layer.borderColor = UIColor.lightGray.cgColor
            thirdRateButton.layer.borderWidth = 2
            thirdRateButton.layer.borderColor = UIColor.blue.cgColor
            chosenHoursLabel.text = "12"
            chosenPriceLabel.text = "8 500 ₸"
            chooseButton.setTitle("Выбрать за 8 500 ₸", for: .normal)
        default:
            break
        }
    }
    @objc private func tapDone() {
        accessToDriverMode(type: selectedType) { isDriver in
            UserDefaults.standard.set(isDriver, forKey: "isDriver")
            self.tapClose()
        }
    }
}

extension RequestForPayViewController {
    func accessToDriverMode(type: Int, completion: @escaping (Bool) -> ()) {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let body : Parameters = ["token" : token,
                                     "driver_type": type]
            Alamofire.request(Constant.api.access, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                if let value = response.result.value, let jsonData = JSON(value).dictionaryObject as [String: Any]?, let statusCode = jsonData["statusCode "] as? Int {
                    guard JSONSerialization.isValidJSONObject(jsonData) else { return }

                    if statusCode == Constant.statusCode.success {
//                            Socket.shared.connect()
                        completion(true)
                    } else {
                        completion(false)
                        indicator.showError(withStatus: "Your money not enough...")
                        indicator.dismiss(withDelay: 1)
                    }

                }
            })
        }
    }
}
