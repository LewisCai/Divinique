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
    
    @IBAction func friendsBtn(_ sender: Any) {
        performSegue(withIdentifier: "friendsSegue", sender: (Any).self)
    }
    var currentUser: String?
    // Declare the location manager
    var locationManager: CLLocationManager!
    
    // Declare the selected annotation
    var selectedAnnotation: CustomAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup map view delegate
        mapView.delegate = self
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Handle location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        
        // Adjust the region to make sure annotations are visible
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Debugging: Print the current location
        print("Current location: \(currentLocation.coordinate)")
        
        // Update user location in Firestore
        updateUserLocation { result in
            switch result {
            case .success:
                print("User location updated successfully.")
                // Add current user's location as an annotation
                self.addCurrentUserAnnotation(at: currentLocation)
                // Fetch other users after updating the current user's location
                self.fetchClosestUsers(currentLocation: currentLocation) { closestUsers in
                    for user in closestUsers {
                        let coordinate = user.location.coordinate
                        let name = user.name
                        let date = user.date
                        let star = user.sign
                        let userId = user.userId
                        let annotation = CustomAnnotation(coordinate: coordinate, name: name, date: date, star: star, userId: userId, currentUserId: self.currentUser)
                        print("Adding annotation at: \(coordinate)") // Debug print
                        self.mapView.addAnnotation(annotation)
                    }
                    // Debug print to verify annotations added to the map
                    print("Total annotations added: \(self.mapView.annotations.count)")
                }
            case .failure(let error):
                print("Failed to update user location: \(error.localizedDescription)")
            }
        }
    }
    
    // Handle annotation selection
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation {
            selectedAnnotation = annotation
            performSegue(withIdentifier: "profileSegue", sender: self)
        }
    }
    
    // Prepare for the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSegue" {
            if let destinationVC = segue.destination as? NearbyUserProfileViewController {
                destinationVC.annotation = selectedAnnotation
            }
        }
    }
    
    // Fetch the closest users' locations from Firestore
    func fetchClosestUsers(currentLocation: CLLocation, completion: @escaping ([(location: CLLocation, name: String, date: String, sign: String, userId: String)]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            var userLocations: [(location: CLLocation, name: String, date: String, sign: String, distance: CLLocationDistance, userId: String)] = []
            
            for document in documents {
                let data = document.data()
                if let latitude = data["latitude"] as? CLLocationDegrees,
                   let longitude = data["longitude"] as? CLLocationDegrees,
                   let name = data["name"] as? String,
                   let date = data["date"] as? String,
                   let sign = data["sign"] as? String,
                   let userId = data["userId"] as? String,
                   userId != Auth.auth().currentUser?.uid { // Exclude current user
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let distance = currentLocation.distance(from: location)
                    userLocations.append((location, name, date, sign, distance, userId))
                }
            }
            
            // Sort by distance and get the closest 5 users
            let closestUsers = userLocations.sorted { $0.distance < $1.distance }.prefix(5)
            let closestUserDetails = closestUsers.map { (location: $0.location, name: $0.name, date: $0.date, sign: $0.sign, userId: $0.userId) }
            
            // Debug print to verify number of annotations
            print("Number of closest user coordinates: \(closestUserDetails.count)")
            
            completion(closestUserDetails)
        }
    }
    
    // Update the user's location in Firestore
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
    
    // Add current user's location as an annotation
    func addCurrentUserAnnotation(at location: CLLocation) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        self.currentUser = currentUserID

        let db = Firestore.firestore()
        db.collection("users").whereField("userId", isEqualTo: currentUserID).getDocuments { (snapshot, error) in
            guard let document = snapshot?.documents.first else {
                print("Error fetching current user document: \(String(describing: error))")
                return
            }
            
            let data = document.data()
            if let name = data["name"] as? String,
               let date = data["date"] as? String,
               let sign = data["sign"] as? String,
               let userId = data["userId"] as? String{
                let annotation = CustomAnnotation(coordinate: location.coordinate, name: name, date: date, star: sign, userId: userId, currentUserId: self.currentUser)
                self.mapView.addAnnotation(annotation)
            }
        }
    }
}
