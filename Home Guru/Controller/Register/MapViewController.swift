//
//  MapViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import MBProgressHUD

protocol MapActionsProtocol {
    func dismissPopUp()
}

class MapViewController: BaseViewController, LocateOnTheMap {
    
    //location manager for accessing current location of the device
    private let locationManager = CLLocationManager()
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationDetailsOuterView: UIView!
    var delegate : MapActionsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = g_address
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        locationDetailsOuterView.roundCorners(radius: 30.0, corners: [.topLeft,.topRight])
        
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if g_lat != nil {
            locateWithLong(lon: g_long, andLatitude: g_lat, andAddress: g_address)
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillLayoutSubviews() {
        locationDetailsOuterView.roundCorners(radius: 30.0, corners: [.topLeft,.topRight])
    }
    
    @IBAction func confirmLocationAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.dismissPopUp()
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeLocationAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locateWithLong(lon: String, andLatitude lat: String, andAddress address: String) {
        let hud = MBProgressHUD()
        self.mapView.addSubview(hud)
        hud.show(animated: true)
        let latDouble = Double(lat)
        let lonDouble = Double(lon)
        GMSGeocoder.init().reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: latDouble!, longitude: lonDouble!)) { (response, error) in
            if let _ = error {
                print("Check Network Connection...")
                hud.hide(animated: true)
                self.showAlert(title: "Message", message: "Couldn't fetch location!")
                return
            }
            guard let response = response, let address = response.firstResult()
                else { return }
            print("address in mapviewcontroller....\(address)")
            g_long = lon
            g_lat = lat
            g_address = address.lines![0]
            g_addressDetails = address
            DispatchQueue.main.async {
                self.mapView.clear()
                let position = CLLocationCoordinate2D(latitude: latDouble!, longitude: lonDouble!)
                let marker = GMSMarker()
                marker.position = position
                marker.iconView = UIImageView(image: UIImage(named:"marker"))
                let camera = GMSCameraPosition.camera(withLatitude: latDouble!, longitude: lonDouble!, zoom: 15)
                self.mapView.camera = camera
                self.locationLabel.text = address.lines![0]
                marker.map = self.mapView
                hud.hide(animated: true)
            }
        }
    }
    
    
}


extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        locateWithLong(lon: "\(coordinate.longitude)", andLatitude: "\(coordinate.latitude)", andAddress: g_address)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        print("Current location is ...\(location.coordinate)")
        locateWithLong(lon: g_long, andLatitude: g_lat, andAddress: g_address)
        locationManager.stopUpdatingLocation()
        
    }
    
}

