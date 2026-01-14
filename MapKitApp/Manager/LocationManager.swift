//
//  LocationManager.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 18/11/25.
//
import CoreLocation
import Foundation
import MapKit

class LocationManager:NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager: CLLocationManager?
    @Published var region: MKCoordinateRegion?
    @Published var Location: CLLocation?
    @Published var error: Error?
    
    
    override init() {
        super.init()
        requestLocation()
        
    }
    
    func requestLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        // Pedimos autorización
    locationManager?.requestWhenInUseAuthorization()
        
        
    }
   
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
            
        //case .authorizedAlways, .authorizedWhenInUse:
         //   print("📍 Permiso concedido — iniciamos actualizaciones")
            
            // 2️⃣ Activamos actualizaciones continuas
          //  locationManager?.startUpdatingLocation()
            
        default:
            locationManager?.requestLocation()
        
            print("❌ Permiso denegado")
            break
        }
          }
          
          // MARK: - Recibir ubicaciones
          func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
              
                 if let lastLocation = locations.last {
                     self.Location = lastLocation     // <-- Corregido: propiedad con minúscula
                     
                     let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                     let newRegion = MKCoordinateRegion(center: lastLocation.coordinate,
                                                        span: span)
                     self.region = newRegion
                 }
             }
             
             // Manejo de errores
             func locationManager(_ manager: CLLocationManager,
                                  didFailWithError error: Error) {
                 self.error = error
             }
         }
