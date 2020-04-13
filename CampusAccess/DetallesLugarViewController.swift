//
//  DetallesLugarViewController.swift
//  CampusAccess
//
//  Created by Frida Gutiérrez Mireles on 10/04/20.
//  Copyright © 2020 Frida Gutiérrez Mireles. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetallesLugarViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbDescripcion: UILabel!
    @IBOutlet weak var btNavegar: UIButton!
    @IBOutlet weak var mapaLugar: MKMapView!
    var lugar : Lugares!
    var longitude : Double!
    var latitude : Double!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbNombre.text = lugar.nombre
        lbDescripcion.text = lugar.description
        btNavegar.layer.cornerRadius = 25.0
        locationManager.requestWhenInUseAuthorization()
     //   mapaLugar.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lugar.latitude, longitude: lugar.longitude)
        annotation.title = lugar.nombre
         mapaLugar.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapaLugar.setRegion(region, animated: true)
            self.mapaLugar.showsUserLocation = true
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    @IBAction func btnDirections(_ sender: UIButton) {
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
        source.name = "Tu"

        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 25.651594, longitude: -100.289555)))
        destination.name = lugar.nombre
        
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
}

