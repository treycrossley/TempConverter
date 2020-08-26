//
//  MapViewController.swift
//  TempConverter
//
//  Created by Admin on 8/22/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var segmentedControl: UISegmentedControl!
    var pointOfInterestLabel: UILabel!
    var pointOfInterestToggle: UISwitch!
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        mapView = MKMapView()
        mapView.showsUserLocation = true
        self.mapView.delegate = self
        view = mapView
        
        setupSegmentedConstraints()
        setupSwitchConstraints()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let spanLength = 0.01
        let span = MKCoordinateSpan(latitudeDelta: spanLength, longitudeDelta: spanLength)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func setupSegmentedConstraints(){
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        
        segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
       
        topConstraint.isActive = true;
        leadingConstraint.isActive = true;
        trailingConstraint.isActive = true;
    }
    
    func setupSwitchConstraints() {
        setupSwitchLabel()
        setupSwitchToggle()
    }
    
    func setupSwitchLabel(){
        pointOfInterestLabel = UILabel();
        view.addSubview(pointOfInterestLabel)
        pointOfInterestLabel.text = NSLocalizedString("Points of Interest", comment: "points of interest along the map")
        pointOfInterestLabel.textAlignment = .left
        pointOfInterestLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pointOfInterestLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            pointOfInterestLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
        ])
        
    }
    
    func setupSwitchToggle(){
        pointOfInterestToggle = UISwitch()
        pointOfInterestToggle.isOn = true
        pointOfInterestToggle.setOn(true, animated: true)
        pointOfInterestToggle.addTarget(self, action: #selector(pointOfInterestToggled(_:)), for: .valueChanged)
        pointOfInterestToggle.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(pointOfInterestToggle)
    
        NSLayoutConstraint.activate([
            pointOfInterestToggle.leadingAnchor.constraint(equalTo: pointOfInterestLabel.trailingAnchor, constant: 5),
            pointOfInterestToggle.bottomAnchor.constraint(equalTo: pointOfInterestLabel.bottomAnchor, constant: 5)
        ])
    }
    
    @objc func pointOfInterestToggled(_ switchControl: UISwitch){
        switch switchControl.isOn {
        case true:
            mapView.pointOfInterestFilter = MKPointOfInterestFilter.includingAll
        case false:
            mapView.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        }
        
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl){
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}
