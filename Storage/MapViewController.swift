
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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate, UITabBarControllerDelegate {
    
    weak var modaleWindowDelegate: ModaleWindowDelegate?
    
    var locationManager: CLLocationManager? = CLLocationManager()
    var delta: Double = 0.01
    var annotations: [Annotation] = []
    var annotation: Annotation?
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    var listMKOverlay: [MKOverlay] = []
    var overlay: MKOverlay?
    
    var pinAnnotationView: MKPinAnnotationView?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newAnnotation: UIBarButtonItem!
    @IBOutlet weak var modaleContainerView: UIView!
    
    private let annotationList = AnnotationList()
    private let preferences = Preferences()
    private let location = Location()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        self.tabBarController?.delegate = self
        
        navigationBarDesign()
        navigationBack()
        design()
        annotations = annotationList.all()
        addGestureRecognizer()
        navigationBarDesign()
        navigationBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnnotations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //updatePosition()
    }
    
    deinit {
        print("Map Deallocated")
    }
    
    // MARK: - Navigation
    
    func newAnnotationDetailsTableViewController(_ annotation: Annotation) {
        let newAnnotationDetailsTableViewController: AnnotationDetailsTableViewController = instantiate("AnnotationDetailsTableViewController", storyboard: "AnnotationDetails")
        let position = location.distance(of: Position.init(lat: annotation.lat, lng: annotation.lng))
        newAnnotationDetailsTableViewController.distance = location.calculateDistance(distance: position)
        newAnnotationDetailsTableViewController.annotation = annotation
        newAnnotationDetailsTableViewController.fromMap = true
        newAnnotationDetailsTableViewController.mapViewControllerDelegate = self
        navigationController?.pushViewController(newAnnotationDetailsTableViewController, animated: true)
    }
    
    func newAnnotationDetailsTableViewController() {
        let newAnnotationDetailsTableViewController: AnnotationDetailsTableViewController = instantiate("AnnotationDetailsTableViewController", storyboard: "AnnotationDetails")
        newAnnotationDetailsTableViewController.lat = lat
        newAnnotationDetailsTableViewController.lng = lng
        newAnnotationDetailsTableViewController.fromMap = true
        newAnnotationDetailsTableViewController.mapViewControllerDelegate = self
        navigationController?.pushViewController(newAnnotationDetailsTableViewController, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction func addAnnotation() {
        guard lat != nil && lng != nil else { return }
        newAnnotationDetailsTableViewController()
    }
    
    // MARK: - Functions
    
    func initMap() {
        
        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Coordonnées de l'utilisateur
            mapView.mapType = MKMapType.standard
            mapView.showsUserLocation = true
            
            if annotation != nil {
                lat = annotation!.lat
                lng = annotation!.lng
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
    
    func showAnnotations() {
        for i in 0..<annotations.count {
            let lat = annotations[i].lat
            let lng = annotations[i].lng
            let favorites = annotations[i].favorite
            let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
            let pointAnnotation = CustomPointAnnotation()
            pointAnnotation.coordinate = pinLocation
            if favorites {
                pointAnnotation.imageName = "FavoritePin"
            } else {
                pointAnnotation.imageName = "Pin"
            }
            pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
            mapView.addAnnotation(pinAnnotationView!.annotation!)
        }
    }
    
    func showAnnotation(_ newAnnotation: Annotation) {
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newAnnotation.lat, newAnnotation.lng)
        let position = location.distance(of: Position.init(lat: newAnnotation.lat, lng: newAnnotation.lng))
        let pointAnnotation = CustomPointAnnotation()
        pointAnnotation.coordinate = pinLocation
        pointAnnotation.title = newAnnotation.title
        pointAnnotation.subtitle = location.calculateDistance(distance: position)
        pointAnnotation.imageName = "Pin"
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        mapView.addAnnotation(pinAnnotationView!.annotation!)
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
        }

        let pin = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: pin.imageName)

        return annotationView
    }
    
    func showAnnotationView() {
        self.mapView.centerCoordinate = CLLocationCoordinate2D(latitude: annotation!.lat, longitude: annotation!.lng)
        let annotationView: AnnotationModaleWindowViewController = instantiate("AnnotationModaleWindowViewController", storyboard: "AnnotationModaleWindow")
        let distance = location.calculateDistance(distance: location.distance(of: Position.init(lat: annotation!.lat, lng: annotation!.lng)))
        annotationView.titleText = annotation!.title
        annotationView.subtitleText = annotation!.subtitle
        annotationView.distanceText = distance
        annotationView.delegate = self
        modaleWindowDelegate = annotationView
        addChild(annotationView, container: modaleContainerView)
        modaleContainerView.isHidden = false
    }
    
    // MARK: - Select Annotation
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard !(view.annotation is MKUserLocation) else { return }
        
        let index = annotations.firstIndex(where: { $0.lat == view.annotation!.coordinate.latitude && $0.lng == view.annotation!.coordinate.longitude })
        guard index != nil else {
            self.mapView(self.mapView, didDeselect: view)
            return
        }
        annotation = annotations[index!]
        guard annotation != nil else { return }
        showAnnotationView()
        showRoute(destinationLat: view.annotation!.coordinate.latitude, destiantionLng: view.annotation!.coordinate.longitude)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        deSelectAnnotation()
    }
    
    private func deSelectAnnotation() {
        annotation = nil
        self.mapView.removeOverlay(overlay!)
        modaleContainerView.isHidden = true
        modaleWindowDelegate?.removeView()
    }
    
    // MARK: - Navigation Controller
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addAnnotation(gestureReconizer:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func updatePosition() {
        annotation = nil
        lat = nil
        lng = nil
    }
    
    // MARK: - Custom Route
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.mainColor
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
            self.overlay = route.polyline
            self.listMKOverlay.append(route.polyline)
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
        }
    }
    
    private func design() {
        modaleContainerView.borderFocus()
    }
    
    private func memoryManager() {
        mapView.delegate = nil
        mapView.removeFromSuperview()
        mapView.mapType = MKMapType.satellite
        mapView = nil
        
        locationManager = nil
        annotations = []
        annotation = nil
        lat = nil
        lng = nil
        pinAnnotationView = nil
    }
}

// MARK: - Protocols

protocol MapViewControllerDelegate: AnyObject {
    func addAnnotation(_ annotation: Annotation)
    func updateAnnotation(_ annotation: Annotation)
    func detailsLastAnnotation(_ annotation: Annotation)
}

extension MapViewController: MapViewControllerDelegate {
    
    func addAnnotation(_ annotation: Annotation) {
        annotations.append(annotation)
        lat = annotation.lat
        lng = annotation.lng
        showAnnotation(annotation)
        showRoute(destinationLat: lat!, destiantionLng: lng!)
    }
    
    func updateAnnotation(_ annotation: Annotation) {
        let index = annotations.firstIndex(where: { $0.id == annotation.id })
        guard index != nil else { return }
        annotations[index!] = annotation
    }
    
    func detailsLastAnnotation(_ annotation: Annotation) {
        self.annotation = annotation
    }
}

protocol RemoveAnnotationDelegate: AnyObject {
    func removeAnnotation(annotation: Annotation)
}

extension MapViewController: RemoveAnnotationDelegate {
    
    func removeAnnotation(annotation: Annotation) {
        var index: Int = 0
        
        for i in 0..<self.annotations.count {
            if self.annotations[i].id == annotation.id {
                index = i
                break
            }
        }
        self.annotations.remove(at: index)
        mapView.removeAnnotations(mapView.annotations)
        showAnnotations()
    }
}

protocol AnnotationModaleWindowDelegate: AnyObject {
    func showAnnotation()
}

extension MapViewController: AnnotationModaleWindowDelegate {
    func showAnnotation() {
        guard annotation != nil else { return }
        newAnnotationDetailsTableViewController(annotation!)
    }
}
