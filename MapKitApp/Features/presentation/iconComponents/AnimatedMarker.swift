//
//  AnimatedMarker.swift
//  MapKitApp
//
//  Created by ALFREDO HIDALGO on 17/12/25.
//

import SwiftUI




struct AnimatedMarker: View {
    @State private var animate = false
    var systemName: String
    var imageColor: Color
    var backgroundColor: Color
    
    var body: some View {
        Image(systemName: systemName)
            .font(.system(size : 36))
        foregroundColor(imageColor)
            .scaleEffect(animate ? 1.3 : 1)
            .opacity(animate ? 0.8 : 1)
           background(Circle()
            .foregroundColor(backgroundColor)
            .frame(width: 64,height: 64)
           )
           .animation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true),value: animate)
           .onAppear {
               animate = true
           }
        
        
        
        
    }
    
}

