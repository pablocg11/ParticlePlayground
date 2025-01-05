//
//  ContentView.swift
//  ParticlePlayground
//
//  Created by Pablo Castro on 6/1/25.
//

import SwiftUI

struct ContentView: View {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    @State private var particles: [Particle] = []
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture { location in
                    generateParticles(at: location)
                }

            ForEach(particles) { particle in
                ParticleView(
                    color: particle.color,
                    size: particle.size,
                    x: particle.x,
                    y: particle.y
                )
            }
        }
        .onReceive(timer) { _ in
            updateParticles()
        }
    }

    func generateParticles(at location: CGPoint) {
        for _ in 0..<300 {
            let angle = Double.random(in: 0..<360)
            let speed = CGFloat.random(in: 10...50)
            let velocityX = cos(angle * .pi / 180) * speed
            let velocityY = sin(angle * .pi / 180) * speed
            let rotation = Double.random(in: 0...360)

            let particle = Particle(
                x: location.x,
                y: location.y,
                size: CGFloat.random(in: 5...10),
                color: Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.9),
                velocityX: velocityX,
                velocityY: velocityY,
                rotation: rotation
            )
            particles.append(particle)
        }
    }

    func updateParticles() {
        particles = particles.map { particle in
            var newParticle = particle
            newParticle.x += particle.velocityX * 0.1
            newParticle.y += particle.velocityY * 0.1
            newParticle.rotation += 5
            return newParticle
        }
        particles.removeAll { particle in
            particle.x < 0 || particle.x > screenWidth || particle.y < 0 || particle.y > screenHeight
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var color: Color
    var velocityX: CGFloat
    var velocityY: CGFloat
    var rotation: Double
}

struct ParticleView: View {
    var color: Color
    var size: CGFloat
    var x: CGFloat
    var y: CGFloat

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .position(x: x, y: y)
            .transition(.scale)
            .animation(.easeOut(duration: 1), value: x)
    }
}

#Preview {
    ContentView()
}
