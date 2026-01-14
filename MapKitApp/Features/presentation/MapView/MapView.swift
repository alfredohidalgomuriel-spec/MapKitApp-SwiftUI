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
    
    
    @Bindable var viewModel:MapViewModel
    @State var showErrorAlert: Bool = false
    @State var lookAroundViewIsExpanded: Bool = false
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ZStack{
            Map(position: $viewModel.cameraPosition, selection: $viewModel.mapSelection) {
                UserAnnotation()
                
            }.mapStyle(viewModel.mapStyle.topMapStyle())
            // modificador  para dar la region
                .onMapCameraChange { ctx in
                    viewModel.viewingRegion = ctx.region
                }
                .overlay(alignment: .topTrailing) {
                    topTraillingOverlayView
                }
                .overlay(alignment: .bottomTrailing) {
                    bottomTraillingOverlayView
                }
                .overlay(alignment: .bottomLeading) {
                    if !viewModel.routeDisplaying {
                        bottomLeadingOverlayView
                    }
                    
                }
            // CAPA 2: El visor de Look Around (Nueva posición fuera del Mapa)
                        // ➡️ Esto es lo que permite que el icono de cerrar sea visible y funcione
                        if viewModel.lookAroundScene != nil {
                            lookAroundPreviewView
                                .transition(.move(edge: .bottom)) // Animación de entrada
                                .zIndex(1) // Asegura que esté por encima de todo
                        }
        }.alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Important message"),
                  message: Text("Unexpected error is happen"),
                  dismissButton: .default(Text("Got it!")))
        }
        
    }
    
    
    
}
