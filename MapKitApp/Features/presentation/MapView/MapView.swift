//
//  MapView.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 18/11/25.
//

import SwiftUI
import Observation
import MapKit

struct MapView: View {
    
    @Bindable var viewModel: MapViewModel
    @State var showErrorAlert: Bool = false
    @State var lookAroundViewIsExpanded: Bool = false
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            // 1. El Reader envuelve al Mapa para traducir toques a coordenadas
            MapReader { proxy in
                Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
                    UserAnnotation()
                    
                    // Dibujamos la línea azul de la ruta si existe
                    if let route = viewModel.route {
                        MapPolyline(route)
                            .stroke(.blue, lineWidth: 5)
                    }
                    // 2. NUEVO: Ponemos un marcador en el destino seleccionado
                        if let destino = viewModel.mapSelection {
                            Marker("Destino", coordinate: destino.placemark.coordinate)
                                .tint(.red) // Lo ponemos rojo para que destaque
                        }
                    
                    // Dibujamos los marcadores de las búsquedas
                    ForEach(viewModel.searchResults, id: \.self) { item in
                        Marker(item.name ?? "Lugar", coordinate: item.placemark.coordinate)
                            .tag(item)
                            .tint(.yellow)
                    }
                }
                .mapStyle(viewModel.mapStyle.topMapStyle)
                // 2. Gesto de toque mejorado
                .onTapGesture { screenPoint in
                    if let coordinate = proxy.convert(screenPoint, from: .local) {
                        // Este mensaje saldrá en la consola de Xcode abajo
                        print("📍 Mapa pulsado en coordenadas: \(coordinate.latitude), \(coordinate.longitude)")
                        
                        // Creamos un punto de destino manual
                        let placemark = MKPlacemark(coordinate: coordinate)
                        let mapItem = MKMapItem(placemark: placemark)
                        mapItem.name = "Destino seleccionado"
                        
                        // Al asignar esto, se activa el .onChange de abajo automáticamente
                        viewModel.mapSelection = mapItem
                    }
                }
                .onMapCameraChange { ctx in
                    viewModel.viewingRegion = ctx.region
                }
            } // CIERRE del MapReader
            
            // CAPA: Botones de arriba (Estilo y Ubicación)
            .overlay(alignment: .topTrailing) {
                topTraillingOverlayView
            }
            
            // CAPA: Botón de temperatura
            .overlay(alignment: .bottomTrailing) {
                bottomTraillingOverlayView
            }
            .overlay(alignment: .bottomTrailing) {
                if viewModel.routeDisplaying { // Solo aparece si hay una ruta dibujada
                    IconView(systemName: "trash.fill",
                             imageColor: .white,
                             rectangleColor: .red)
                        .padding(.bottom, 160) // Lo ponemos encima del botón de temperatura
                        .onTapGesture {
                            // Limpiamos los datos con una animación suave
                            withAnimation {
                                viewModel.route = nil
                                viewModel.travelTime = nil
                                viewModel.mapSelection = nil
                                viewModel.routeDisplaying = false
                                
                            }
                        }
                        .transition(.scale.combined(with: .opacity)) // Aparece y desaparece elegante
                }
            }
            
            // CAPA: Botón de Binoculares (Look Around)
            .overlay(alignment: .bottomLeading) {
                if !viewModel.routeDisplaying {
                    bottomLeadingOverlayView
                }
            }
            
            // CAPA: Mostrar el TIEMPO estimado arriba en el centro
            .overlay(alignment: .top) {
                if let tiempo = viewModel.travelTime {
                    Text("Llegada en: \(tiempo)")
                        .font(.headline) // Letra más destacada
                        .foregroundStyle(.white) // Texto blanco
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Capsule().fill(.black.opacity(0.7))) // Forma de cápsula oscura
                        .shadow(radius: 5)
                        .padding(.top, 60) // Para no tapar el reloj del iPhone
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            // CAPA: Visor de Look Around
            if viewModel.lookAroundScene != nil {
                lookAroundPreviewView
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
            }
            
        } // CIERRE del ZStack
        
        // 3. Este bloque detecta cuando cambia la selección y pide la ruta
        .onChange(of: viewModel.mapSelection) { oldValue, newValue in
            if let lugarSeleccionado = newValue {
                print("✅ Destino fijado: \(lugarSeleccionado.name ?? "Punto en mapa")")
                
                // Movemos la cámara al destino
                withAnimation {
                    viewModel.cameraPosition = .item(lugarSeleccionado)
                }
                
                // Calculamos la ruta
                Task {
                    await viewModel.calculateRoute()
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text("No se pudo completar la acción"), dismissButton: .default(Text("OK")))
        }
    }
}
