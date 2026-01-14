//
//  HomeView.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 18/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var manager: LocationManager
    
    var body: some View {
        if let location = manager.Location,
           let region = manager.region {
            MapView(viewModel: MapViewModel(location: location, region: region))
        }else{
            ProgressView()
            
        }
        
    }
    
}
