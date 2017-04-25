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
    var landmark: Landmark?
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
        // Pull landmarks from Realm
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        
        for landmark in landmarks {
            let annotation = LandmarkPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(landmark.latitude, landmark.longitude)
            
            // Only display landmark name if it has been visited
            annotation.title = (landmark.visited) ? landmark.name : "???"
            
            annotation.landmark = landmark
            mapView.addAnnotation(annotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        
        // Update & report user's current location
        locManager.startUpdatingLocation()
        
        // Set up the mapview
        mapView.delegate = self
        mapView.mapType = MKMapType.hybrid
        mapView.showsUserLocation = true
        
        addTourDestinations()
        
        centerMapOnLocation(location: CLLocation(latitude: 40.698143, longitude: -89.616412))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Bradley UTour"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LandmarkSelect" {
            let destination = segue.destination as! LandmarkViewController
            let landmarkAnnotation = (sender as! MKAnnotationView).annotation as! LandmarkPointAnnotation
            
            destination.landmark = landmarkAnnotation.landmark
        }
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
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // Insert the button to the landmark details page
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        
        // Change the color of the unvisited landmarks
        if annotation.title! == "???" {
            view.pinTintColor = UIColor.gray
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! LandmarkPointAnnotation
        
        // Only display the landmark's detail page if the user has visited that location
        if (annotation.landmark?.visited)! {
            if control == view.rightCalloutAccessoryView {
                performSegue(withIdentifier: "LandmarkSelect", sender: view)
            }
        } else {
            let ac = UIAlertController(title: "Hol' up!", message: "You haven't visited this place yet.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

}
