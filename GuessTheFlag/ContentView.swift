//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Muhammad Dzaky on 12/09/24.
//

import SwiftUI

struct ContentView: View {
    var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"]
    var correctAnswer = Int.random(in: 0...2)
    
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            VStack(spacing: 30) {
                // Body Message
                VStack {
                    Text("Tap the Flag of")
                    Text(countries[correctAnswer])
                }
                .padding()
                ForEach(0..<3) {number in
                    Button {
                        // flag tapped
                    } label: {
                        Image(countries[number])
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
