
//
//  MapViewController.swift
//  Storage
//
//  Created by Luc-Antoine Dupont on 25/01/2017.
//  Copyright © 2017 Luc-Antoine Dupont. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITabBarControllerDelegate, AddAnnotationDelegate, RemoveAnnotationDelegate {
    
    var locationManager: CLLocationManager? = CLLocationManager()
    var delta: Double = 0.01
    var annotation: [Annotation]?
    var thisAnnotation: Annotation?
    var index: Int?
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    var unLoadMap: Bool?
    var listMKOverlay: [MKOverlay] = []
    
    var pinAnnotationView: MKPinAnnotationView?
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let db = DataBase()
    private let preferences = Preferences()
    private let location = Location()
    private let model = ModelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 23.0), NSAttributedString.Key.foregroundColor: UIColor.white]        
        mapView.delegate = self
        self.tabBarController?.delegate = self
        
        db.getAnnotation(completion: { results in
            self.annotation = results
        })
        
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initMap()
        updateNavigationControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnnotation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updatePosition()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard unLoadMap == nil else { return }
        //memoryManager()
    }
    
    deinit {
        print("Map deinit")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "AddAnnotation":
            let destination = segue.destination as! AnnotationTableViewController //AddAnnotationViewController
            destination.lat = lat
            destination.lng = lng
            destination.fromMap = true
            destination.title = NSLocalizedString("Add annotation", comment: "")
            destination.addAnnotationDelegate = self
            unLoadMap = true
            
        case "showDetails":
            let destination = segue.destination as! AnnotationTableViewController //DetailsAnnotationViewController
            let thisAnnotation = sender! as? Annotation
            destination.annotation = annotation!
            destination.thisAnnotation = thisAnnotation
            destination.fromMap = true
            destination.title = model.calculateDistance(distance: location.distance(of: Position(lat: thisAnnotation!.lat, lng: thisAnnotation!.lng)))
            destination.removeAnnotationDelegate = self
            destination.index = index!
            
        default:
            break
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func addPin(_ sender: Any) {
        guard lat != 0 && lng != 0 else { return }
    }
    
    // MARK: - Delegate
    
    func addAnnotation(annotation: Annotation) {
        self.annotation!.append(annotation)
        lat = annotation.lat
        lng = annotation.lng
        showAnnotation()
        showRoute(destinationLat: lat!, destiantionLng: lng!)
    }
    
    func removeAnnotation(annotation: Annotation) {
        var index: Int = 0
        
        for i in 0..<self.annotation!.count { // self.annotation! = nil !!!!
            if self.annotation?[i].id == annotation.id {
                index = i
                break
            }
        }
        self.annotation?.remove(at: index)
        mapView.removeAnnotations(mapView.annotations)
        showAnnotation()
    }
    
    // MARK: - Functions
    
    func initMap() {
        
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Coordonnées de l'utilisateur
            mapView.mapType = MKMapType.standard
            mapView.showsUserLocation = true
            
            /*if lat == nil {
                lat = (locationManager!.location?.coordinate.latitude)!
                lng = (locationManager!.location?.coordinate.longitude)!
                showRoute(destinationLat: lat!, destiantionLng: lng!)
            }*/
            
            if thisAnnotation != nil {
                lat = thisAnnotation!.lat
                lng = thisAnnotation!.lng
                showRoute(destinationLat: lat!, destiantionLng: lng!)
            } else {
                if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                    lat = (locationManager!.location?.coordinate.latitude)!
                    lng = (locationManager!.location?.coordinate.longitude)!
                } else {
                    lat = 48.86053457621386
                    lng = 2.2957536578178406
                }
            }
            
            // Coordonnées de la région
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, lng!)
            let region = MKCoordinateRegion.init(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - Annotation
    
    @objc func addAnnotation(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        let annotation = CustomPointAnnotation()
        annotation.coordinate = coordinate
        
        lat = annotation.coordinate.latitude
        lng = annotation.coordinate.longitude
    }
    
    func showAnnotation() {
        for i in 0..<annotation!.count {
            let lat = annotation![i].lat
            let lng = annotation![i].lng
            let title = annotation![i].title
            let favorites = annotation![i].favorite
            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
            let position = location.distance(of: Position.init(lat: lat, lng: lng))
            let pointAnnotation = CustomPointAnnotation()
            pointAnnotation.coordinate = pinLocation
            pointAnnotation.title = title
            pointAnnotation.subtitle = model.calculateDistance(distance: position)
            if favorites {
                pointAnnotation.imageName = "PinsFav"
            } else {
                pointAnnotation.imageName = "Pins"
            }
            pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            mapView.addAnnotation(pinAnnotationView!.annotation!)
        }
    }
    
    // MARK: - Custom Annotation
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) { return nil }
        if !(annotation is CustomPointAnnotation) { return nil }
        
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let pin = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: pin.imageName)
        
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        //showRoute(destinationLat: annotation.coordinate.latitude, destiantionLng: annotation.coordinate.longitude)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        for i in 0..<annotation!.count {
            if view.annotation?.title! == annotation![i].title {
                index = i
            }
        }
        
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "showDetails", sender: annotation![index!])
        }
    }
    
    // MARK: - Select Annotation
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else { return }
        showRoute(destinationLat: view.annotation!.coordinate.latitude, destiantionLng: view.annotation!.coordinate.longitude)
    }
    
    // MARK: - Tab Bar Navigation Controller Delegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        unLoadMap = true
    }
    
    // MARK: - Navigation Controller
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addAnnotation(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func updatePosition() {
        thisAnnotation = nil
        lat = nil
        lng = nil
    }
    
    private func updateNavigationControllers() {
        switch navigationController!.viewControllers.count {
        case 3:
            navigationController!.viewControllers.remove(at: 1)
            
        case 4:
            let viewControllerFirst = navigationController?.viewControllers.first
            let viewControllerLast = navigationController?.viewControllers.last
            navigationController?.viewControllers = [viewControllerFirst!, viewControllerLast!]
            
        default:
            break
        }
    }
    
    //MARK: - Custom Route
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.appColor
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    private func showRoute(destinationLat: CLLocationDegrees, destiantionLng: CLLocationDegrees) {
        let currentLat: CLLocationDegrees?
        let currentLng: CLLocationDegrees?
        mapView.removeOverlays(listMKOverlay)
        listMKOverlay.removeAll()
        
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLat = (locationManager!.location?.coordinate.latitude)!
            currentLng = (locationManager!.location?.coordinate.longitude)!
        } else {
            currentLat = 48.86053457621386
            currentLng = 2.2957536578178406
        }
        
        // Set the latitude and longtitude of the locations
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLng!)
        let destinationLocation = CLLocationCoordinate2D(latitude: destinationLat, longitude: destiantionLng)
        
        // Create placemark objects containing the location's coordinates
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // MKMapitems are used for routing. This class encapsulates information about a specific point on the map
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // The MKDirectionsRequest class is used to compute the route.
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // The route will be drawn using a polyline as a overlay view on top of the map.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.listMKOverlay.append(route.polyline)
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
    }
    
    private func memoryManager() {
        mapView.delegate = nil
        mapView.removeFromSuperview()
        mapView.mapType = MKMapType.satellite
        mapView = nil
        
        locationManager = nil
        annotation = nil
        thisAnnotation = nil
        index = nil
        lat = nil
        lng = nil
        pinAnnotationView = nil
    }
}
