//
//  ContentView.swift
//  ShakeTutorial
//
//  Created by Fatih Durmaz on 1.07.2024.
//

import SwiftUI
import Lottie

struct ContentView: View {
    @State private var shakeStarted = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if shakeStarted {
                    Text("Shaking!")
                        .padding()
                        .font(.largeTitle)
                        .transition(.opacity)
                    
                } else {
                    Text("Not Shaking!")
                        .padding()
                        .font(.largeTitle)
                        .transition(.opacity)
                }
                
                if shakeStarted {
                    LottieView(animation: .named("vibrate"))
                        .looping()
                }
                Spacer()
            }
            .onShake(start: {
                withAnimation {
                    self.shakeStarted = true
                }
            }, finish: {
                Task {
                    try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                    withAnimation {
                        self.shakeStarted = false
                    }
                    print("Shaking finished!")
                    
                }
            })
            .sensoryFeedback(.error, trigger: shakeStarted)
            .navigationTitle("SwiftUI Shake")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ContentView()
}

