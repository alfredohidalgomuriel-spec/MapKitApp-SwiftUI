//
//  MapViewComponents.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 17/12/25.
//

import MapKit
import SwiftUI

// MARK: - Top Trailing Overlay
extension MapView {
    var topTraillingOverlayView: some View {
        VStack(spacing: 8) { // Spacing positivo para orden visual
            // Cambio de estilo de mapa
            IconView(systemName: "map.fill")
                .onTapGesture {
                    viewModel.mapStyle = viewModel.mapStyle.toggle()
                }
            
            if viewModel.isLoading {
                loadingIndicator
            } else {
                recenterButton
            }
        }
    }
    
    // Subcomponente privado para el indicador de carga
    private var loadingIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 44, height: 46)
                .foregroundColor(.init(.systemBackground))
            ProgressView()
        }
    }
    
    // Subcomponente para centrar la cámara
    private var recenterButton: some View {
        IconView(systemName: "location.fill")
            .onTapGesture {
                withAnimation(.spring()) {
                    viewModel.cameraPosition = .region(viewModel.region)
                }
            }
    }
}

// MARK: - Bottom Trailing Overlay (Clima)
extension MapView {
    var bottomTraillingOverlayView: some View {
        HStack(spacing: 4) {
            IconView(systemName: "sun.min.fill", imageColor: .yellow)
            
            Text("17°")
                .foregroundColor(.gray)
                .font(.title3)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 46)
                .foregroundColor(.init(.systemBackground))
        )
        .padding(.bottom, 100) // Reemplazamos offset por padding para mejor layout
    }
}

// MARK: - Bottom Leading Overlay (Exploración)
extension MapView {
    var bottomLeadingOverlayView: some View {
        IconView(systemName: "binoculars.fill")
            .frame(width: 62, height: 46)
            .padding(.bottom, 100)
            .onTapGesture {
                handleLookAroundAction()
            }
    }
    
    // Extraemos la lógica a una función privada para limpiar la UI
    private func handleLookAroundAction() {
        Task { @MainActor in
            guard let coordinate = viewModel.viewingRegion?.center else {
                showErrorAlert = true
                return
            }
            await viewModel.fetchLookAroundPreview(coordinate: coordinate)
        }
    }
}

// MARK: - Look Around Preview View
extension MapView {
    var lookAroundPreviewView: some View {
        VStack {
            LookAroundPreview(scene: $viewModel.lookAroundScene)
                .frame(height: lookAroundViewIsExpanded ? UIScreen.main.bounds.height - 40 : 200)
                .cornerRadius(15)
                .overlay(alignment: .topTrailing) {
                    lookAroundControls
                }
                .padding(.horizontal, 8)
            
            if !lookAroundViewIsExpanded {
                Spacer()
            }
        }
    }
    
    // Agrupamos los controles de la vista inmersiva
    private var lookAroundControls: some View {
        VStack(spacing: 12) {
            // Cerrar
            IconView(systemName: "xmark.circle.fill")
                .onTapGesture {
                    resetLookAroundState()
                }
            
            // Expandir/Contraer
            IconView(systemName: lookAroundViewIsExpanded ?
                     "arrow.down.right.and.arrow.up.left" :
                     "arrow.up.backward.and.arrow.down.forward")
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        lookAroundViewIsExpanded.toggle()
                    }
                }
        }
        .padding(12)
    }
    
    @MainActor
    private func resetLookAroundState() {
        viewModel.lookAroundScene = nil
        viewModel.isLoading = false
        lookAroundViewIsExpanded = false
    }
}
