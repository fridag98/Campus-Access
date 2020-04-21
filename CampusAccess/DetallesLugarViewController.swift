//
//  DetallesLugarViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
//import MapKit
import CoreLocation
import GoogleMaps
import GoogleMapsDirections
import Alamofire
import SwiftyJSON

class DetallesLugarViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbDescripcion: UILabel!
    @IBOutlet weak var btNavegar: UIButton!
    @IBOutlet weak var googleMaps: GMSMapView!
    
    var lugar : Lugares!
    var longitude : Double!
    var latitude : Double!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GMSServices.provideAPIKey("KEY")
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.651022, longitude: -100.289712, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.googleMaps.frame, camera: camera)
        self.view.addSubview(mapView)
        self.googleMaps?.isMyLocationEnabled = true
        
        //marker en el lugar seleccionado
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lugar.latitude, longitude: lugar.longitude)
        marker.title = lugar.nombre
        marker.map = mapView
        
        lbNombre.text = lugar.nombre
        lbDescripcion.text = lugar.description
        btNavegar.layer.cornerRadius = 25.0

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
       /* let cameraPositionCoordinates = CLLocationCoordinate2D(latitude: 25.651022, longitude: -100.289712)
        let cameraPosition = GMSCameraPosition.camera(withTarget: cameraPositionCoordinates, zoom: 18)

        let mapView = GMSMapView.map(withFrame: googleMaps.frame, camera: cameraPosition)
        mapView.isMyLocationEnabled = true

        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(25.651470, -100.291025)
        marker.position = CLLocationCoordinate2D(latitude: lugar.latitude, longitude: lugar.longitude)
        marker.title = lugar.nombre
        marker.map = mapView
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(25.651470, -100.291025))
        path.add(CLLocationCoordinate2DMake(25.651806, -100.290234))
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView

        self.view.addSubview(mapView)*/
        
        /*let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lugar.latitude, longitude: lugar.longitude)
        annotation.title = lugar.nombre
         mapaLugar.addAnnotation(annotation)*/
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
          //  let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
           // let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            //mapaLugar.setRegion(region, animated: true)
            //self.mapaLugar.showsUserLocation = true
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    @IBAction func btnDirections(_ sender: UIButton) {
        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json?origin=25.651470,-100.291025&destination=25.651806, -100.290234&mode=walking&key=APIKEY").responseJSON { response in
            let result = response.result
            if let result = result.value as? Dictionary<String, AnyObject> {
                if let routes = result["routes"] as? [Dictionary<String, AnyObject>] {
                    if let distance = routes[0]["legs"] as? [Dictionary<String, AnyObject>] {
                        print(distance[0]["distance"]?["text"] as! String)
                        print(distance[0]["duration"]?["text"] as! String)
                    }
                }
            }
        }

       /* let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        source.name = "Tu"

        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.651594, longitude: -100.289555)))
        destination.name = lugar.nombre
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])*/

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

