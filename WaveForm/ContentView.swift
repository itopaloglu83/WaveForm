//
//  ContentView.swift
//  WaveForm
//
//  Created by İhsan TOPALOĞLU on 7/25/21.
//

import SwiftUI

struct Wave: Shape {
    var strength: Double
    var frequency: Double
    var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth
        let wavelength = width / frequency
        
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let distanceFromMidWith = x - midWidth
            let normalizedDistance = oneOverMidWidth * distanceFromMidWith
            let parabola = 1 - (normalizedDistance * normalizedDistance)
            let sine = sin(relativeX + phase)
            
            let y = parabola * strength * sine + midHeight
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
}

struct ContentView: View {
    @State private var phase = 0.0
    
    var body: some View {
        ZStack {
            ForEach(0..<10) { i in
                Wave(strength: 50, frequency: 10, phase: phase)
                    .stroke(Color.white.opacity(Double(i) / 10), lineWidth: 5)
                    .offset(y: CGFloat(i) * 10)
            }
        }
        .background(Color.blue)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phase = .pi * 2
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
