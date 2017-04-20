//
//  MapViewController.swift
//  BradleyUTour
//
//  Created by Castor, Alexander on 4/11/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

class LandmarkPointAnnotation : MKPointAnnotation {
    var pinColor: UIColor?
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locManager: CLLocationManager!
    var tourDestinations: [CLLocation] = []
    @IBOutlet weak var mapView: MKMapView!
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 150
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addTourDestinations() {
        // pull destinations from Realm
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        
        for landmark in landmarks {
            let annotation = LandmarkPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(landmark.latitude, landmark.longitude)
            
            // only display the landmark name if it has been visited?
            if landmark.visited {
                annotation.title = landmark.name
            } else{
                annotation.title = "???"
                annotation.pinColor = UIColor.gray
            }
            
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        // update & report user's current location
        locManager.startUpdatingLocation()
        
        // set up the mapview
        mapView.delegate = self
        mapView.mapType = MKMapType.hybrid
        mapView.showsUserLocation = true
        
        addTourDestinations()
        
        let initialLocation = CLLocation(latitude: 40.698143, longitude: -89.616412)
        centerMapOnLocation(location: (initialLocation))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation

        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "You are here!"
        
        mapView.addAnnotation(myAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
        } else {
            annotationView?.annotation = annotation
        }
        
        if annotation.title! == "???" {
            let annotation = annotation as! LandmarkPointAnnotation
            annotationView?.pinTintColor = annotation.pinColor
        }
        
        return annotationView
    }
}
