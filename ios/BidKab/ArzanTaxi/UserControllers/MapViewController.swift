//
//  MapViewController.swift
//  BidKab
//
//  Created by Nursultan on 08.03.2019.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces

protocol PlaceDelegate{
    func place(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, _ name: String)
}

class MapViewController: UIViewController {

    lazy var locationManager: CLLocationManager = CLLocationManager()
    lazy var pointChooseMarker = GMSMarker(position: CLLocationCoordinate2D())
    lazy var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var delegate: PlaceDelegate?
    lazy var home = 10

    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.delegate = self

        return mapView
    }()

    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.text = ""

        return label
    }()

    lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .black)
        button.backgroundColor = .blue
        
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarTransparent(title: nil, shadowImage: false)

        configureMapView()
        setupViews()
    }

    @objc private func continueButtonPressed(){
        if home == 10 {
            self.continuePress()
        } else if home == 1 {
            getAddUserAddress(home: true, lat: coordinate.latitude, long: coordinate.longitude, title: placeLabel.text!)
        } else {
            getAddUserAddress(home: false, lat: coordinate.latitude, long: coordinate.longitude, title: placeLabel.text!)
        }
    }
    
    private func continuePress() {
        delegate?.place(coordinate.latitude, coordinate.longitude, placeLabel.text!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func getAddUserAddress(home: Bool, lat: Double, long: Double, title: String) -> Void {
        if let token = UserDefaults.standard.string(forKey: "token") {
            let url = "http://185.111.106.48/api/profile/address_edit"
            let homeParams: [String: Any] = ["token": token, "home_lat": lat, "home_lng": long, "home_address": title]
            let workParams: [String: Any] = ["token": token, "work_lat": lat, "work_lng": long, "work_address": title]
            let params = home ? homeParams : workParams
            print("PARAMSSS ", params)
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .failure(let error):
                    print("Error: \(error)")
                    break
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: PlaceListViewController.self) {
                            self.navigationController!.popToViewController(controller, animated: true)
                            break
                        }
                    }
                    break
                }
            })
        }
    }

    private func configureMapView(){
        mapView.setMinZoom(10, maxZoom: 25)
        locationManager.delegate = self
        pointChooseMarker.map = mapView
        locationManager.startUpdatingLocation()
    }

    private func setupViews(){
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (mapView) in
            mapView.edges.equalToSuperview()
        }
        view.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { (placeLabel) in
            placeLabel.top.equalTo(mapView).offset(UIViewController.heightNavBar * 2)
            placeLabel.centerX.equalToSuperview()
        }
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { (continueButton) in
            continueButton.centerX.equalToSuperview()
            continueButton.bottom.equalToSuperview().offset(-30)
            continueButton.width.equalToSuperview().multipliedBy(0.3)
            continueButton.height.equalTo(40)
        }
    }

}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        coordinate = position.target
        pointChooseMarker.position = coordinate
        getPlaceName(coordinate.latitude, coordinate.longitude, placeLabel)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = locations.last

        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15)

        pointChooseMarker.position = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        coordinate = location!.coordinate

        print("itni")

        mapView.camera = camera
        getPlaceName(location!.coordinate.latitude, location!.coordinate.longitude, placeLabel)
    }
}
