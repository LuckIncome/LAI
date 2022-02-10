//
//  PassengerInMapViewController.swift
//  BidKab
//
//  Created by Nursultan on 26.02.2019.
//  Copyright © 2019 Nursultan Zhiyembay. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class PassengerInMapViewController: UIViewController {

    var locationManager: CLLocationManager = CLLocationManager()

    var driverPosition: CLLocation = CLLocation()
    var pointAPosition: CLLocation = CLLocation()
    var pointBPosition: CLLocation = CLLocation()

    lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()

        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        configureMarkers()
        setupViews()
    }

    private func configureMapView(){
        GMSServices.provideAPIKey(GMS_API_KEY)
        GMSPlacesClient.provideAPIKey(GMS_API_KEY)
        mapView.delegate = self
        mapView.setMinZoom(10, maxZoom: 25)
    }

    private func configureMarkers(){
        let driverMarker: GMSMarker = GMSMarker(position: driverPosition.coordinate)
        let pointAmarker: GMSMarker = GMSMarker(position: pointAPosition.coordinate)
        let pointBmarker: GMSMarker = GMSMarker(position: pointBPosition.coordinate)

        driverMarker.icon = #imageLiteral(resourceName: "taxi_icon")
        pointAmarker.icon = #imageLiteral(resourceName: "marker_a")
        pointBmarker.icon = #imageLiteral(resourceName: "marker_b")

        driverMarker.map = mapView
        pointAmarker.map = mapView
        pointBmarker.map = mapView

        mapView.camera = GMSCameraPosition.camera(withTarget: driverMarker.position, zoom: 15)
        drawPath(startLocation: driverPosition, endLocation: pointAPosition)
        drawPath(startLocation: pointAPosition, endLocation: pointBPosition)
    }

    func drawPath(startLocation: CLLocation, endLocation: CLLocation) {
        let parameters : [String : String] = ["key" : "\(GMS_API_KEY)", "sensor" : "false", "mode" : "driving", "alternatives" : "false", "origin" : "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)", "destination" : "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"]
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?mode=driving")

        Alamofire.request(url!, method: .get, parameters: parameters).responseJSON { (response) in
            let json = JSON(response.data!)
            let routes = json["routes"].arrayValue
            // print route using Polyline

            print("Route: \(routes.count) \(json)")

            for route in routes {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath(fromEncodedPath: points!)
                let polyline = GMSPolyline(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = .blue
                polyline.map = self.mapView
            }
        }
    }

    private func setupViews(){
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (mapView) in
            mapView.edges.equalToSuperview()
        }
    }

}

extension PassengerInMapViewController: GMSMapViewDelegate {

}
