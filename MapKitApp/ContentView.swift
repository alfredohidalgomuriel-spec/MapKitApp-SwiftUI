//
import SwiftUI
import MapKit

struct ContentView: View {
    
    // Recibimos el LocationManager desde el environment
    @EnvironmentObject var manager: LocationManager
    
    var body: some View {
        HomeView()
        
    }
    
    /*   Group {
     if let region = manager.region {
     // Cuando ya tenemos la localización → mostramos el mapa
     Map(initialPosition: .region(region)) {
     UserAnnotation()
     }
     } else {
     // Pantalla de carga mientras esperamos ubicación
     VStack(spacing: 12) {
     ProgressView()
     Text("Buscando ubicación...")
     .font(.caption)
     .foregroundStyle(.gray)
     }
     }
     }
     .onAppear {
     manager.requestLocation()
     }
     }
     }
     
     #Preview {
     ContentView()
     .environmentObject(LocationManager())
     }
     */
}
