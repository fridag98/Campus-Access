//
//  DetallesLugarViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GoogleMapsDirections
import Alamofire

class DetallesLugarViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbDescripcion: UILabel!
    @IBOutlet weak var btNavegar: UIButton!
    @IBOutlet weak var googleMaps: GMSMapView!
    
    @IBOutlet weak var imgElevator: UIImageView!
    @IBOutlet weak var imgToilet: UIImageView!
    @IBOutlet weak var lbElevator: UILabel!
    @IBOutlet weak var lbToilet: UILabel!
    @IBOutlet weak var lbExtraInfo: UILabel!
    
    var lugar : Lugar!
    var longitude : Double!
    var latitude : Double!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: lugar.latitude, longitude: lugar.longitude, zoom: 18.0)
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.camera = camera
        self.googleMaps.animate(to: camera)
        self.googleMaps.delegate = self
        
        //marker of selected place
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: lugar.latitude, longitude: lugar.longitude)
        destinationMarker.title = lugar.nombre
        destinationMarker.map = googleMaps
        
        //temporal marker simulating current location at Tec
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: 25.651470, longitude: -100.291025)
        sourceMarker.title = "Tu ubicacion"
        sourceMarker.map = googleMaps
        
        //show availability
        if !lugar.ambulatorios {
            imgToilet.isHidden = true
            lbToilet.isHidden = true
        }
        if !lugar.elevadores {
            imgElevator.isHidden = true
            lbElevator.isHidden = true
        }
        
        //show prompt of special elevators
        if lugar.nombre == "Aulas 4" || lugar.nombre == "Aulas 7" {
            lbExtraInfo.alpha = 1
           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
               self.lbExtraInfo.alpha = 0
           }
        }
        
        lbNombre.text = lugar.nombre
        lbDescripcion.text = lugar.description
        btNavegar.layer.cornerRadius = 25.0

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func paintRoute(fromApiResult apikey : Dictionary<String, AnyObject>) {
        guard let routes = apikey["routes"] as? [Any] else {
            return
        }

        guard let route = routes[0] as? [String: Any] else {
            return
        }
        

        guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
            return
        }
        
        guard let polyLineString = overview_polyline["points"] as? String else {
            return
        }
                
        let path = GMSPath.init(fromEncodedPath: polyLineString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .black
        polyline.strokeWidth = 3.0
        polyline.map = self.googleMaps
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.651470, longitude: -100.291025, zoom: 20.0)
        self.googleMaps.camera = camera
        self.googleMaps.animate(to: camera)
    }
    
    @IBAction func btnDirections(_ sender: UIButton) {
        
        // TODO: - Change this to env variable
        let apiKey = "YOUR_API_KEY" //DO NOT COMMIT THIS TO GITHUB
        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?origin=25.651470,-100.291025&destination=\(lugar.latitude),\(lugar.longitude)&mode=walking&key=\(apiKey)").responseJSON { response in
            
            if let result = response.result.value as? Dictionary<String, AnyObject> {
                if let error = result["error_message"] {
                    print("There was a problem with the Google API request: \(error)")
                }
                else {
                    self.paintRoute(fromApiResult: result)
                }
            }
        }
    }
    
   /* func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }*/
}

