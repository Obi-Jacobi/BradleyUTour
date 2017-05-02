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
            //func addRadiusOverlay(forGeotification geotification: Geotification) {
            mapView.add(MKCircle(center: annotation.coordinate, radius:CLLocationDistance(annotation.radius)))
            //}
            
            monitorLocation(landmarkPointAnnotation: annotation)
        }
    }
    
    func region(withLandmark landmarkPointAnnotation: LandmarkPointAnnotation) -> CLCircularRegion {
        //print("regionWithLandmark")
        let landmark = landmarkPointAnnotation.landmark
        let coordinate = CLLocationCoordinate2D(latitude: (landmark?.latitude)!, longitude: (landmark?.longitude)!)
        
        let region = CLCircularRegion(center: coordinate, radius: CLLocationDistance(landmarkPointAnnotation.radius), identifier: (landmark?.name)!)
        
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    func monitorLocation(landmarkPointAnnotation: LandmarkPointAnnotation) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle: "Error", message: "Geofencing is not supported on this device! :(")
            return
        }
        
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle: "Warning", message: "Please grant UTour permission to access your device's location")
        }
        
        let region = self.region(withLandmark: landmarkPointAnnotation)
        print(region.notifyOnEntry)
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Bradley UTour"
        notificationContent.subtitle = "You have vistied, \(landmarkPointAnnotation.landmark?.name)"
        notificationContent.body = "Good job! Keep it up!"
        
        
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "bradley_utour_local_notification", content: notificationContent, trigger: trigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
        
        
        locManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(landmarkPointAnnotation: LandmarkPointAnnotation) {
        for region in locManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == landmarkPointAnnotation.landmark?.name else { continue }
            locManager.stopMonitoring(for: circularRegion)
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
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.userLocation.title = "You're here"
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        addTourDestinations()
        
        centerMapOnLocation(location: CLLocation(latitude: 40.698143, longitude: -89.616412))
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success
                        else {
                            return
                    }
                    //self.scheduleLocalNotification()
                })
            case .authorized:
                print("authorized")
                
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        })
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapView.reloadInputViews()
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
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let userLocation:CLLocation = locations[0] as CLLocation
//
//        // Drop a pin at user's Current Location
//        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        myAnnotation.title = "You are here!"
//        
//        mapView.addAnnotation(myAnnotation)
    }*/
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Did Enter Region: \(region.identifier)")
        //print(region)
        let realm = try! Realm()
        let landmarks = realm.objects(Landmark.self)
        
        for landmark in landmarks {
            if landmark.name == region.identifier {
                //landmark.visited = true
                try! realm.write {
                    landmark.visited = true
                }
                //mapView.
                //self.locManager.refres
                //
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("Did Visit \(visit)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Did exit Region: \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if(annotation.isEqual(mapView .userLocation)) {
                view.canShowCallout = true
                view.pinTintColor = UIColor.blue
            } else {
                // Insert the button to the landmark details page
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
        }
        
        // Change the color of the unvisited landmarks
        if annotation.title! == "???" {
            view.pinTintColor = UIColor.gray
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.lineWidth = 1.0
            circleRenderer.strokeColor = .purple
            circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
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
        } else {
            showAlert(withTitle: "UnvisitedLocation", message: "You have not visited this location yet, keep searching!")
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
        print("notification time \(notification)")
    }
    
}
