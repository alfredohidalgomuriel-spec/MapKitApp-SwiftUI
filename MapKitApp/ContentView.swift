//
import SwiftUI
import MapKit

struct ContentView: View {
    
    // Recibimos el LocationManager desde el environment
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
        HomeView()
        
    }
    
    
}
