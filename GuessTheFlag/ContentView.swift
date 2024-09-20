//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Muhammad Dzaky on 12/09/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gradAnimate = true
    
    // Data state variable
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Alert state variable
    @State private var scoreTitle = ""
    @State private var alertMessage = ""
    @State private var alertButtonCopy = ""
    @State private var showingScore = false
    
    // Tap function state variables
    @State private var userScore = 0
    @State private var tappedFlag : String = ""
    @State private var tapCount = 0

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradAnimate ? [Color(red: 0.98, green: 0.98, blue: 0.98), Color(red:0.87, green: 0.87, blue: 0.87)] : [.red, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: gradAnimate)
            VStack(spacing: 32) {
                VStack(spacing: 24) {
                    // Body Message
                    VStack(spacing: 8) {
                        Text("Tap the Flag of")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    .padding()
                    ForEach(0..<3) {number in
                        Button {
                            // flag tapped
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius:2)
                        }
                    }
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(.regularMaterial.opacity(0.4))
                Text("Score: \(userScore)")
                    .font(.headline.weight(.semibold))
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button(alertButtonCopy, action: askQuestion)
        } message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped (_ number: Int) {
        tapCount += 1
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            alertMessage = "You've got 10 points!"
            userScore += 10
            withAnimation {
                gradAnimate = true
            }
        } else {
            scoreTitle = "Wrong"
            alertMessage = "That is the flag of \(countries[number])."
            if userScore == 0 {
                userScore = 0
            } else {
                userScore -= 5
            }
            withAnimation {
                gradAnimate = false
            }
        }
        
        if tapCount == 8 {
            tapCount = 0
            scoreTitle = "Final Score"
            alertMessage = "You've got \(userScore) points!"
            alertButtonCopy = "Play Again"
        } else {
            alertButtonCopy = "Next Question"
        }
        
        showingScore = true
    }
    
    func askQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        gradAnimate = true
    }
}

#Preview {
    ContentView()
}
