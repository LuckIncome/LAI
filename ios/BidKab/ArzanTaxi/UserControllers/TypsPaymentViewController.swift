//
//  TypsPaymentViewController.swift
//  ArzanTaxi
//
//  Created by MAC on 07.08.2018.
//  Copyright © 2018 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import InputMask
import MaterialTextField

class TypsPaymentViewController: UIViewController, MaskedTextFieldDelegateListener {

    var maskedDelegate : MaskedTextFieldDelegate?
    var paymentTypes: [PaymentType] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var items: [String] = [.localizedString(key: "balanceCard"),
               .localizedString(key: "balanceSMS"),
               .localizedString(key: "balanceUnits"),
               .localizedString(key: "balanceUser"),
               .localizedString(key: "balanceKassa24"),
               .localizedString(key: "balanceQiwi")]
    let cellID = "cell"
    var amount: Int = 0
    
    lazy var tableView : UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.tableFooterView = UIView()
        tv.rowHeight = UITableViewAutomaticDimension
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = .localizedString(key: "pay")
        paymentTypes = [
            CardPayment(vc: self),
            SMSPayment(vc: self),
            BalancePayment(vc: self),
            UserBalancePayment(vc: self),
            Kassa24Payment(vc: self),
            QiwiPayment(vc: self)
        ]
        
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
        
        if let revealController = revealViewController() {
            view.addGestureRecognizer(revealController.panGestureRecognizer())
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        }
        
        maskedDelegate = MaskedTextFieldDelegate(primaryFormat: "{+7} [000] [000] [00] [00]")
        maskedDelegate?.listener = self
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}

extension TypsPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentType = paymentTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = paymentType.title
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let paymentType = paymentTypes[indexPath.row]
        paymentType.processPayment()
    }
}

extension TypsPaymentViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "+7"
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.count < 2 {
            textField.text = "+7"
        } else if text.count > 12 {
            textField.text = String(text.dropLast())
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text == "+7" else { return }
        textField.text = nil
    }
}
