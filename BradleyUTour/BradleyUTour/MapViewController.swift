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
        
        let initialLocation = CLLocation(latitude: 40.698143, longitude: -89.616412)
        centerMapOnLocation(location: (initialLocation))
        
        
        // Display user's current location
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: true)
        
        // Drop a pin at user's Current Location
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
//        // update the label text
//        address.text = "\(locations[0])"
//        myLocations.append(locations[0] as CLLocation)
//        
//        let spanX = 0.007
//        let spanY = 0.007
//        let newRegion = MKCoordinateRegion(center: mapInfo.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
//        mapInfo.setRegion(newRegion, animated: true)
//        
//        // for rendering overlay object purpose
//        if (locations.count > 1) {
//        let sourceIndex = myLocations.count - 1
//        let destIndex = myLocations.count - 2
//        
//        let srcCoord = myLocations[sourceIndex].coordinate
//        let destCoord = myLocations[destIndex].coordinate
//        var srcDestCoord = [srcCoord, destCoord]
//        let polyLine = MKPolyline(coordinates: &srcDestCoord, count: srcDestCoord.count)
//        mapInfo.add(polyLine)
//        }
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
