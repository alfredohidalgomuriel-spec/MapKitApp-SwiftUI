//
//  MapViewModel.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 18/11/25.
//
import Foundation
import SwiftUI
import Observation
import MapKit

// MARK: - Enum para los estilos del mapa
enum MyMapStyle: Int {
    
    case standard = 0
    case imagery
    case hybrid
    
    func topMapStyle() -> MapStyle {
        switch self {
        case .standard: return .standard
        case .imagery: return .imagery
        case .hybrid: return .hybrid
        }
    }
    
    func toggle() -> MyMapStyle {
        switch self {
        case .standard: return .imagery
        case .imagery: return .hybrid
        case .hybrid: return .standard
        }
    }
}

// MARK: - ViewModel del mapa
@Observable class MapViewModel {
    
    var cameraPosition: MapCameraPosition
    var location: CLLocation?
    var region: MKCoordinateRegion
    var mapSelection: MKMapItem?
    
    // Valor inicial del estilo del mapa
    var mapStyle: MyMapStyle = .standard
    var isLoading: Bool = false
    var viewingRegion: MKCoordinateRegion?
    var routeDisplaying: Bool = false
    var lookAroundScene: MKLookAroundScene?
    
    init(location: CLLocation?,
         region: MKCoordinateRegion) {
        self.cameraPosition = .region(region)
        self.location = location
        self.region = region
    }
}

// MARK: - Extensión con Lógica de Look Around (CORRECCIÓN DE COMPILACIÓN)

extension MapViewModel {
    
    // ➡️ Usamos @MainActor para asegurar que la UI se actualice sin errores de memoria
    @MainActor
    func fetchLookAroundPreview(coordinate: CLLocationCoordinate2D) async {
        
        self.isLoading = true
        self.lookAroundScene = nil
       let request = MKLookAroundSceneRequest(coordinate: coordinate)
        lookAroundScene = try? await request.scene
            
        // apagar el  circulo  de   carga
        self.isLoading = false
        
        
    }
}
        
        
        
    





