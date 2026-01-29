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

// MARK: - Estilos del Mapa
enum MyMapStyle: Int {
    case standard = 0
    case imagery
    case hybrid
    
    var topMapStyle: MapStyle {
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

// MARK: - ViewModel
@Observable
final class MapViewModel { // 'final' mejora el rendimiento al evitar herencia
    
    // Propiedades de Ruta
    var route: MKRoute?
    var travelTime: String?
    var routeDisplaying: Bool = false
    
    // Propiedades de Mapa y Localización
    var searchResults: [MKMapItem] = []
    var cameraPosition: MapCameraPosition
    var location: CLLocation?
    var region: MKCoordinateRegion
    var viewingRegion: MKCoordinateRegion?
    var mapSelection: MKMapItem?
    
    // Estado de la UI
    var mapStyle: MyMapStyle = .standard
    var isLoading: Bool = false
    var lookAroundScene: MKLookAroundScene?
    
    // Formateador profesional para tiempo de viaje (Estandariza "15 min" según idioma)
    private let timeFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    init(location: CLLocation?, region: MKCoordinateRegion) {
        self.location = location
        self.region = region
        self.cameraPosition = .region(region)
    }
}

// MARK: - Lógica Asíncrona
extension MapViewModel {
    
    /// Obtiene la vista inmersiva de una coordenada
    @MainActor
    func fetchLookAroundPreview(coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        lookAroundScene = nil
        
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        
        do {
            // Usamos 'try await' en lugar de 'try?' para tener control total
            lookAroundScene = try await request.scene
        } catch {
            print("DEBUG: Error al cargar Look Around: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    /// Calcula la ruta entre la posición actual y el destino seleccionado
    @MainActor
    func calculateRoute() async {
        guard let source = location?.coordinate,
              let destination = mapSelection?.placemark.coordinate else { return }
        
        resetRoute()
        isLoading = true // Feedback visual mientras calcula
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        do {
            let response = try await directions.calculate()
            if let primaryRoute = response.routes.first {
                self.route = primaryRoute
                self.routeDisplaying = true
                self.travelTime = formatTravelTime(primaryRoute.expectedTravelTime)
            }
        } catch {
            print("DEBUG: Error al calcular ruta: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Métodos de Apoyo (Helpers)
    
    private func resetRoute() {
        route = nil
        routeDisplaying = false
        travelTime = nil
    }
    
    private func formatTravelTime(_ seconds: TimeInterval) -> String {
        let duration = Measurement(value: seconds, unit: UnitDuration.seconds)
        return timeFormatter.string(from: duration)
    }
}
        
        
    





