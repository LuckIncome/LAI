//
//  PlaceViewController.swift
//  BidKab
//
//  Created by Nursultan on 08.03.2019.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit
import GooglePlaces
import Alamofire
import SwiftyJSON

class PlaceListViewController: UIViewController {
    
    var fetcher: GMSAutocompleteFetcher?
    var delegate: PlaceDelegate?
    var isAorB: Bool = false
    let cellID = "placeCellID"
    let userId = UserDefaults.standard.string(forKey: "user_id") ?? ""
    var massiv = [String]()
    var history: [UserHistoryAddress] = [] {
        didSet{
            self.address = self.history
        }
    }
    
    var address:[UserHistoryAddress] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var homeAddress: [UserHistoryAddress] = [] {
        didSet {
            if !self.homeAddress.isEmpty{
                if self.homeAddress[0].from != "" {
                    self.address = self.homeAddress + self.address
                    hideAddButtons()
                }
            }
        }
    }
    
    var workAddress: [UserHistoryAddress] = [] {
        didSet {
            if !self.workAddress.isEmpty {
                if self.workAddress[0].from != "" {
                    self.address = self.workAddress + self.address
                    hideAddButtons()
                }
            }
        }
    }
    
    var places: [GMSAutocompletePrediction] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
//        searchBar.tintColor = .white
//        searchBar.barTintColor = .white
//        searchBar.setImage(UIImage(), for: .search, state: .normal)
        return searchBar
    }()
    
    lazy var searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "poisk")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .blue
        return icon
    }()
    
    lazy var searchBottomView: UIView = {
        let sbv = UIView()
        sbv.backgroundColor = .blue
        return sbv
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        return tableView
    }()
    
    lazy var addHomeAddressButton: UIButton = {
        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        button.setTitle("Добавить адрес (дом)", for: .normal)
        button.setImage(#imageLiteral(resourceName: "HomeAddress"), for: .normal)
        button.tintColor = .white
        button.tag = 0
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        button.layer.cornerRadius = 25
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(addressButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var addWorkAddressButton: UIButton = {
        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        button.setTitle("Добавить адрес (работа)", for: .normal)
        button.setImage(#imageLiteral(resourceName: "workAdsress"), for: .normal)
        button.tintColor = .white
        button.tag = 1
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        button.layer.cornerRadius = 25
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(addressButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        button.setTitle("Указать на карте", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        button.layer.cornerRadius = 20
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PlaceListTableViewCell.self, forCellReuseIdentifier: cellID)
        configureFetcher()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarTransparent(title: nil, shadowImage: true)
        history.removeAll()
        homeAddress.removeAll()
        workAddress.removeAll()
        address.removeAll()
        getUserAddressHistory()
    }
    
    @objc private func mapButtonPressed(sender: UIButton){
        let controller = MapViewController()
        controller.pointChooseMarker.icon = isAorB ? #imageLiteral(resourceName: "pointa") : #imageLiteral(resourceName: "pointb")
        controller.delegate = self.navigationController!.viewControllers[0] as! HomeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func addressButtonPressed(sender: UIButton){
        if sender.tag == 0 {
            let controller = MapViewController()
            controller.home = 1
            controller.delegate = self.navigationController!.viewControllers[0] as! HomeViewController
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = MapViewController()
            controller.home = 0
            controller.delegate = self.navigationController!.viewControllers[0] as! HomeViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func configureFetcher(){
        let nsBoundsCorner = CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629)
        
        let bounds = GMSCoordinateBounds(coordinate: nsBoundsCorner, coordinate: nsBoundsCorner)
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        fetcher  = GMSAutocompleteFetcher(bounds: bounds, filter: filter)
        fetcher?.delegate = self
    }
    
    private func getPlaceDetails(_ placeId: String){
        let url = "https://maps.googleapis.com/maps/api/place/details/json?input=bar&language=en&placeid=\(placeId)&key=\(GMS_API_KEY)"
        Alamofire.request(url).responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                print("Error: \(error)")
                break
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let latitude = json["result"]["geometry"]["location"]["lat"].doubleValue
                let longitude = json["result"]["geometry"]["location"]["lng"].doubleValue
                let array = json["result"]["address_components"].arrayValue
                let address = array[0]["long_name"].stringValue
                let street = array[1]["long_name"].stringValue
                self.endChoose(latitude, longitude, "\(street), \(address)")
                break
            }
        }
    }
    
    private func getUserAddress() -> Void {
        
        if let phone = UserDefaults.standard.string(forKey: "phoneNumber") {
            User.authUser(body: ["phone" : phone.removingWhitespaces()], completion: { (result, user, statusCode) in
                if statusCode == Constant.statusCode.success {
                    let json = JSON(result)
                    print(json)
                    print("HOMEEE: ", user.home_address)
                    self.workAddress.append(UserHistoryAddress(from: user.work_address!, from_lat: user.work_lat!, from_lon: user.work_lng!))
                    self.homeAddress.append(UserHistoryAddress(from: user.home_address!, from_lat: user.home_lat!, from_lon: user.home_lng!))
                    print("WORKKK: ", user.work_address)
                }
            })
        }
        

    }
    
    private func getUserAddressHistory() -> Void {
        let url = "http://185.111.106.48/api/order_address_history"
        if let token = UserDefaults.standard.string(forKey: "token"){
            let params = ["token": token]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .failure(let error):
                    print("Error: \(error)")
                    break
                case .success(let value):
                    DispatchQueue.main.async {
                        let json = JSON(value)
                        for i in 0 ..< json["result"].arrayValue.count{
                            self.history.append(UserHistoryAddress(from: json["result"].arrayValue[i]["from"].stringValue, from_lat: json["result"].arrayValue[i]["from_lat"].doubleValue, from_lon: json["result"].arrayValue[i]["from_lon"].doubleValue))
                        }
                        self.getUserAddress()
                    }
                    break
                }
            })
        }
    }
    
    private func homeAddressIsEmpty() -> Bool {
        if homeAddress.first?.from == "" || homeAddress.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func workAddressIsEmpty() -> Bool {
        if workAddress.first?.from == "" || workAddress.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func hideAddButtons() -> Void {
        if !workAddressIsEmpty() && !homeAddressIsEmpty() {
            addWorkAddressButton.isHidden = true
            addHomeAddressButton.isHidden = true
            
            tableView.snp.makeConstraints { (tableView) in
                tableView.top.equalTo(searchBottomView.snp_bottomMargin)
                tableView.bottom.equalTo(mapButton.snp_topMargin).offset(-20)
                tableView.width.equalToSuperview()
            }
            
            
        } else if !workAddressIsEmpty() {
            addWorkAddressButton.isHidden = true
            
            addHomeAddressButton.snp.makeConstraints { (mapButton) in
                mapButton.width.equalToSuperview().multipliedBy(0.8)
                mapButton.bottom.equalTo(self.mapButton.snp.top).offset(-20)
                mapButton.centerX.equalToSuperview()
                mapButton.height.equalTo(50)
            }
            
            tableView.snp.makeConstraints { (tableView) in
                tableView.top.equalTo(searchBottomView.snp_bottomMargin)
                tableView.bottom.equalTo(addHomeAddressButton.snp_topMargin).offset(-20)
                tableView.width.equalToSuperview()
            }
            
        } else if !homeAddressIsEmpty() {
            addHomeAddressButton.isHidden = true
            
            tableView.snp.makeConstraints { (tableView) in
                tableView.top.equalTo(searchBottomView.snp_bottomMargin)
                tableView.bottom.equalTo(addWorkAddressButton.snp_topMargin).offset(-20)
                tableView.width.equalToSuperview()
            }
            
        }
    }
        
        private func endChoose(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ name: String){
            delegate?.place(latitude, longitude, name)
            print("EBAAA: ", latitude, longitude, name )
            self.navigationController?.popViewController(animated: true)
        }
        
        private func setupViews(){
            let navBarHeight = navigationController?.navigationBar.frame.height
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            view.backgroundColor = .white
            view.addSubview(searchBar)
            searchBar.snp.makeConstraints { (searchBar) in
                if #available(iOS 11.0, *) {
                    searchBar.top.equalTo(view.safeAreaLayoutGuide)
                } else {
                    searchBar.top.equalToSuperview().offset(navBarHeight! + statusBarHeight)
                }
                searchBar.left.equalToSuperview().offset(5)
                searchBar.right.equalToSuperview()
                searchBar.height.equalTo(70)
            }
//            view.addSubview(searchIcon)
//            searchIcon.snp.makeConstraints { (icon) in
//                icon.top.left.equalTo(searchBar)
//                icon.height.equalTo(70)
//                icon.width.equalTo(40)
//            }
            view.addSubview(searchBottomView)
            searchBottomView.snp.makeConstraints { (searchBarView) in
                searchBarView.top.equalTo(searchBar.snp.bottom)
                searchBarView.left.right.equalToSuperview()
                searchBarView.height.equalTo(8)
            }
            view.addSubview(mapButton)
            mapButton.snp.makeConstraints { (mapButton) in
                mapButton.width.equalToSuperview().multipliedBy(0.9)
                mapButton.bottom.equalToSuperview().offset(-40)
                mapButton.centerX.equalToSuperview()
                mapButton.height.equalTo(60)
            }
            view.addSubview(addWorkAddressButton)
            addWorkAddressButton.snp.makeConstraints { (mapButton) in
                mapButton.width.equalToSuperview().multipliedBy(0.8)
                mapButton.bottom.equalTo(self.mapButton.snp.top).offset(-20)
                mapButton.centerX.equalToSuperview()
                mapButton.height.equalTo(50)
            }
            view.addSubview(addHomeAddressButton)
            addHomeAddressButton.snp.makeConstraints { (mapButton) in
                mapButton.width.equalToSuperview().multipliedBy(0.8)
                mapButton.bottom.equalTo(self.addWorkAddressButton.snp.top).offset(-10)
                mapButton.centerX.equalToSuperview()
                mapButton.height.equalTo(50)
            }
            view.addSubview(tableView)
            tableView.snp.makeConstraints { (tableView) in
                tableView.top.equalTo(searchBottomView.snp_bottomMargin)
                tableView.bottom.equalTo(addHomeAddressButton.snp_topMargin).offset(-10)
                tableView.width.equalToSuperview()
            }
        }
    }
    
    extension PlaceListViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if !searchBar.text!.isEmpty {
                return places.count
            } else {
                return address.count
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PlaceListTableViewCell
            cell.textLabel?.textColor = .blue
            cell.placeIcon.image = UIImage()
            if !searchBar.text!.isEmpty {
                cell.textLabel!.text = places[indexPath.row].attributedFullText.string
            } else {
                cell.textLabel?.text = address[indexPath.row].from
                if workAddressIsEmpty() && homeAddressIsEmpty() {
                    cell.placeIcon.image = #imageLiteral(resourceName: "history-1")
                } else if !homeAddressIsEmpty() && workAddressIsEmpty() {
                    if indexPath.row == 0 {
                        cell.placeIcon.image = #imageLiteral(resourceName: "address")
                    } else {
                        cell.placeIcon.image = #imageLiteral(resourceName: "history-1")
                    }
                } else if homeAddressIsEmpty() && !workAddressIsEmpty() {
                    if indexPath.row == 0 {
                        cell.placeIcon.image = #imageLiteral(resourceName: "portfolio")
                    } else {
                        cell.placeIcon.image = #imageLiteral(resourceName: "history-1")
                    }
                } else {
                    if indexPath.row == 0 {
                        cell.placeIcon.image = #imageLiteral(resourceName: "address")
                    } else if indexPath.row == 1 {
                        cell.placeIcon.image = #imageLiteral(resourceName: "portfolio")
                    } else {
                        cell.placeIcon.image = #imageLiteral(resourceName: "history-1")
                    }
                }

            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            if !searchBar.text!.isEmpty {
                getPlaceDetails(places[indexPath.row].placeID!)
            } else {
                self.endChoose(address[indexPath.row].from_lon, address[indexPath.row].from_lat, address[indexPath.row].from)
            }
        }
    }
    
    extension PlaceListViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            fetcher?.sourceTextHasChanged(searchText)
        }
    }
    
    extension PlaceListViewController: GMSAutocompleteFetcherDelegate {
        
        func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
            places = predictions
        }
        
        func didFailAutocompleteWithError(_ error: Error) {
            print(error.localizedDescription)
        }
}
