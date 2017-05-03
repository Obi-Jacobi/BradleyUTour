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
import UserNotifications

class LandmarkPointAnnotation : MKPointAnnotation {
    var landmark: Landmark?
    let radius = 25
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UNUserNotificationCenterDelegate {
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
            if !landmark.visited {
                mapView.add(MKCircle(center: annotation.coordinate, radius:CLLocationDistance(annotation.radius)))
            }
        }
    }
    
    func region(withLandmark landmarkPointAnnotation: LandmarkPointAnnotation) -> CLCircularRegion {
        let landmark = landmarkPointAnnotation.landmark
        let coordinate = CLLocationCoordinate2D(latitude: (landmark?.latitude)!, longitude: (landmark?.longitude)!)
        
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(landmarkPointAnnotation.radius), identifier: (landmark?.name)!)
        
        return region
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
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.userLocation.title = "You're here!"
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        addTourDestinations()
        
        centerMapOnLocation(location: CLLocation(latitude: 40.698143, longitude: -89.616412))
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
        self.addTourDestinations()
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
    
    //MARK: MapView stuff
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            
            if annotation.title! == "???" {
                view.pinTintColor = UIColor.gray
            }
            else {
                view.pinTintColor = UIColor.red
            }
        }
        else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if(annotation.isEqual(mapView .userLocation)) {
                view.canShowCallout = true
                view.pinTintColor = UIColor.blue
            } else {
                
                // Change the color of the unvisited landmarks
                if annotation.title! == "???" {
                    view.pinTintColor = UIColor.gray
                }
                else {
                    view.pinTintColor = UIColor.red
                }
                
                // Insert the button to the landmark details page
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
        }
        
        
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.lineDashPattern = [6,3]
            circleRenderer.strokeColor = .gray
            circleRenderer.fillColor = UIColor.gray.withAlphaComponent(0.2)
            return circleRenderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation = view.annotation as! LandmarkPointAnnotation
        
        // Only display the landmark's detail page if the user has visited that location
        if (annotation.landmark?.visited)! {
            if control == view.rightCalloutAccessoryView {
                performSegue(withIdentifier: "LandmarkSelect", sender: view)
            }
        }
        else {
            let region = self.region(withLandmark: annotation)
            print(region.identifier)
            if region.contains(mapView.userLocation.coordinate) {
                let realm = try! Realm()
                let landmarks = realm.objects(Landmark.self)
                
                for landmark in landmarks {
                    if landmark.name == region.identifier {
                        try! realm.write {
                            landmark.visited = true
                        }
                        mapView.removeAnnotations(mapView.annotations)
                        mapView.removeOverlays(mapView.overlays)
                        self.addTourDestinations()
                    }
                }
                showAlert(withTitle: "Visited: \(region.identifier)", message: "Good job! Keep it up!")
            }
            else {
                showAlert(withTitle: "Please try again!", message: "You are not in range of this landmark. Please move closer!")
            }
        }
    }
}
