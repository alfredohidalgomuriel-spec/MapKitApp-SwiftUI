//
//  MapKitAppApp.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 18/11/25.
//

import SwiftUI
  
@main
struct MapKitAppApp: App {
    @StateObject var manager = LocationManager()
   
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager)
        }
    }
}
