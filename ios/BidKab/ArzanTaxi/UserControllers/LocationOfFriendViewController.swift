//
//  LocationOfFriendViewController.swift
//  ArzanTaxi
//
//  Created by Zhiyembay Nursultan on 11/16/17.
//  Copyright © 2017 Zhiyembay Nursultan. All rights reserved.
//

import UIKit
import GoogleMaps
import SnapKit
import Alamofire
import SwiftyJSON

class LocationOfFriendViewController : UIViewController, CLLocationManagerDelegate {
    
    var mapsView : GMSMapView?
    var locationManager = CLLocationManager()
    var fromCoordinate : CLLocationCoordinate2D?
    var friendLocation: CLLocation? {
        didSet {
            guard let location = friendLocation else { return }
            print(location.coordinate.latitude)
        }
    }
    var myCurrentLocation: CLLocation? {
        didSet {
            guard let location = myCurrentLocation else { return }
            print(location.coordinate.latitude)
        }
    }
    
    let user : User
    
    init(friend: User) {
        self.user = friend
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var myPositionButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "my_location"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleMyLocation), for: .touchUpInside)
        
        return button
    }()
    
    lazy var showRouteButton : UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("Show Route", for: .normal)
        button.backgroundColor = .blue
        button.tintColor = .white
        button.addTarget(self, action: #selector(drawRoute), for: .touchUpInside)
        
        return button
    }()
    
    @objc func drawRoute() {
        guard let startLocation = myCurrentLocation, let endLocation = friendLocation else { return }
        drawPath(startLocation: startLocation, endLocation: endLocation)
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let parameters : [String : String] = ["key" : "AIzaSyCAE04sxw3yd3H2QmZmBqsnNITX-gzFol8", "sensor" : "false", "mode" : "driving", "alternatives" : "false", "origin" : "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)", "destination" : "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"]
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?mode=driving")
        
        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { (response) in
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            // print route using Polyline
            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = .blue
                polyline.map = self.mapsView
            }
        }
    }
    
    @objc func handleMyLocation() {
        if let latitude = locationManager.location?.coordinate.latitude, let longitude = locationManager.location?.coordinate.longitude {
            self.myCurrentLocation = CLLocation(latitude: latitude, longitude: longitude)
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
            
            mapsView?.animate(to: camera)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        //let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        myCurrentLocation = CLLocation(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, zoom: 15)
        
        mapsView?.camera = camera
        mapsView?.isMyLocationEnabled = true
        
        locationManager.stopUpdatingLocation()
    }
    
    func friendPosiiton() {
        if let id = user.id {
            Socket.shared.friendPosition(id: id, completion: { (lat, lon) in
                self.mapsView?.clear()
                self.friendLocation = CLLocation(latitude: lat, longitude: lon)
                let markerA = GMSMarker()
                
                markerA.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                markerA.icon = #imageLiteral(resourceName: "friend")
                markerA.map = self.mapsView
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey(GMS_API_KEY)
        
        mapsView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(mapsView!)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapsView?.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        mapsView?.setMinZoom(10, maxZoom: 25)
        
        view.addSubview(myPositionButton)
        view.addSubview(showRouteButton)
        
        myPositionButton.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-15)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        showRouteButton.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.bottom.equalTo(-15)
            make.height.equalTo(45)
        }
        friendPosiiton()
    }
}
