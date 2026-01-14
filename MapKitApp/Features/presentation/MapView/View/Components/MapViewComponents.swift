//
//  MapViewComponents.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 17/12/25.
//


import MapKit
import SwiftUI


extension MapView {
    var topTraillingOverlayView: some View {
        VStack(spacing: -5) {
            IconView(systemName: "map.fill")
                .onTapGesture {
                    self.viewModel.mapStyle = viewModel.mapStyle.toggle()
                }
            
            if viewModel.isLoading {
                // Contenedor para el ProgressView
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 44, height: 46)
                        .foregroundColor(.init(.systemBackground))
                    ProgressView()
                }
                .padding(.top, 5)
            } else {
                IconView(systemName: "location.fill")
                    .onTapGesture {
                        withAnimation {
                            viewModel.cameraPosition = .region(viewModel.region)
                        }
                    }
            }
        }
    }
}
// MARK: - Bottom trailing Overlay View
//   boton  de temperatura  y estado   del tiempo
extension MapView {
    // Esta vista  es  la del   boton  de la temperatura
    var bottomTraillingOverlayView: some View {
        HStack(spacing: -10) {
            IconView(systemName: "sun.min.fill",
                     imageColor:.yellow)
                .offset(x: -10)
            Text("17°")
                .foregroundColor(.init(.gray))
                .font(.title3)
                .offset(x: -13)
        }.background(
            RoundedRectangle(cornerRadius: 10)
            .frame(width:62,height: 46)
            .foregroundColor(.init(.systemBackground))
        ).offset(y: -100)
    }
}
// MARK: - Bottom Leading Overlay View   Zoom


extension MapView {
    
    var bottomLeadingOverlayView: some View {
        IconView(systemName: "binoculars.fill")
            .frame(width: 62, height: 46)
            .offset(y: -100)
            .onTapGesture {
                // Ejecutamos en el hilo principal para evitar el crash
                                Task { @MainActor in
                                    guard let coordinate = viewModel.viewingRegion?.center else {
                                        showErrorAlert = true
                                        return
                                    }
                                    await viewModel.fetchLookAroundPreview(coordinate: coordinate)
                                }
                            }
                    }
                }

// MARK: - Look Around Preview View (Iconos de cerrar corregidos)
extension MapView {
    var lookAroundPreviewView: some View {
        VStack {
            LookAroundPreview(scene: $viewModel.lookAroundScene)
                .frame(height: lookAroundViewIsExpanded ? UIScreen.main.bounds.height - 32 : 200)
                .cornerRadius(15) // Añadimos bordes redondeados
                .overlay(alignment: .topTrailing) {
                    VStack(spacing: 12) {
                        // BOTÓN CERRAR
                        IconView(systemName: "xmark.circle.fill")
                            .frame(width: 44, height: 44)
                            .onTapGesture { // cerrar  todo
                                Task { @MainActor in
                                    viewModel.lookAroundScene = nil
                                    viewModel.isLoading = false
                                    lookAroundViewIsExpanded = false
                                }
                            }
                        
                        // BOTÓN EXPANDIR
                        IconView(systemName: lookAroundViewIsExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.backward.and.arrow.down.forward")
                            .frame(width: 44, height: 44)
                            .onTapGesture {
                                Task { @MainActor in
                                    withAnimation {
                                        lookAroundViewIsExpanded.toggle()
                                    }
                                }
                            }
                    }
                    .padding(12)
                }
                .padding(.horizontal, 8)
            
            if !lookAroundViewIsExpanded {
                Spacer()
            }
        }
    }
}
