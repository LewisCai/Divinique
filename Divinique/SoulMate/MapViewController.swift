//
//  MapViewController.swift
//  Divinique
//
//  Created by LinjunCai on 5/6/2024.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background image
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
            .foregroundColor: UIColor.white
        ]
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "LoginBackground")
        backgroundImage.contentMode = .scaleAspectFill
        view.addSubview(backgroundImage)
        view.sendSubviewToBack(backgroundImage)
        
        // Setup map view
        mapView.delegate = self
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        updateUserLocation { result in
            switch result {
            case .success:
                print("User location updated successfully.")
            case .failure(let error):
                print("Failed to update user location: \(error.localizedDescription)")
            }
        }
        
        fetchClosestUsers(currentLocation: currentLocation) { closestCoordinates in
            for coordinate in closestCoordinates {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                print("Adding annotation at: \(coordinate)") // Debug print
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationIdentifier = "UserAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            
            // Add a detail button to the callout
            let detailButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func fetchClosestUsers(currentLocation: CLLocation, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            var userLocations: [(location: CLLocation, distance: CLLocationDistance)] = []
            
            for document in documents {
                let data = document.data()
                if let latitude = data["latitude"] as? CLLocationDegrees,
                   let longitude = data["longitude"] as? CLLocationDegrees {
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let distance = currentLocation.distance(from: location)
                    userLocations.append((location, distance))
                }
            }
            
            // Sort by distance and get the closest 5 users
            let closestUsers = userLocations.sorted { $0.distance < $1.distance }.prefix(5)
            let closestCoordinates = closestUsers.map { $0.location.coordinate }
            
            completion(closestCoordinates)
        }
    }
    
    func updateUserLocation(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        // Ensure location manager has a valid location
        guard let location = locationManager.location else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Location not available"])))
            return
        }
        
        let db = Firestore.firestore()
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        
        // Fetch the user document by userId field
        db.collection("users").whereField("userId", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("User document not found: \(String(describing: error))")
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User document not found"])))
                return
            }
            
            for document in documents {
                document.reference.setData(locationData, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("User document updated successfully")
                        completion(.success(()))
                    }
                }
            }
        }
    }
}
