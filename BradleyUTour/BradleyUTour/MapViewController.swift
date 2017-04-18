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
        
//        for landmark in landmarks {
//            mapView.addAnnotation(landmark)
//        }
        
//        mapView.addAnnotations(landmarks)
        // create annotations and add them to the mapView
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
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer  {
//        if (overlay is MKPolyline) {
//            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
//            polyLineRenderer.strokeColor = UIColor.blue .withAlphaComponent(0.5)
//            polyLineRenderer.lineWidth = 4
//            return polyLineRenderer
//        }
//        return MKPolylineRenderer()
//    }
}
