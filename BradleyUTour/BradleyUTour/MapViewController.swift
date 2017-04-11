//
//  MapViewController.swift
//  BradleyUTour
//
//  Created by Castor, Alex on 4/11/17.
//  Copyright © 2017 Bradley University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var locManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    @IBOutlet weak var mapInfo: MKMapView!
    
    let regionRadius: CLLocationDistance = 100
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapInfo.setRegion(coordinateRegion, animated: true)
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
        mapInfo.delegate = self
        mapInfo.mapType = MKMapType.standard
        let initialLocation = CLLocation(latitude: 40.698158, longitude: -89.616026)
        centerMapOnLocation(location: (initialLocation))
        mapInfo.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer  {
        if (overlay is MKPolyline) {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = UIColor.blue .withAlphaComponent(0.5)
            polyLineRenderer.lineWidth = 4
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
}
