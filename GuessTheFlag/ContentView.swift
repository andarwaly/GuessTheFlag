//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Muhammad Dzaky on 12/09/24.
//

import SwiftUI


struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius:2)
    }
}

extension View {
    func flagImage() -> some View {
        modifier(FlagImage())
    }
}

struct ContentView: View {
    
    @State private var gradAnimate = true
    
    // Data state variable
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Alert state variable
    @State private var activeAlert: ActiveAlert?
    @State private var showingScore = false
    
    // Tap function state variables
    @State private var userScore = 0
    @State private var tappedFlag : String = ""
    @State private var tapCount = 0
    
    enum ActiveAlert {
        case correct, wrong, result
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: gradAnimate ? [Color(red: 0.98, green: 0.98, blue: 0.98), Color(red:0.87, green: 0.87, blue: 0.87)] : [.red, .blue]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: gradAnimate)
            
            VStack(spacing: 0) {
                VStack(spacing: 44) {
                    // Body Message
                    VStack(spacing: 8) {
                        Text("Tap the Flag of")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    VStack(spacing: 24){
                        ForEach(0..<3) {number in
                            Button {
                                // flag tapped
                                flagTapped(number)
                            } label: {
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .flagImage()
                            }
                        }
                    }
                }
                .frame(maxWidth:.infinity, maxHeight: .infinity)
                .background(.regularMaterial.opacity(0.4))
                
                HStack (alignment: .center) {
                    Text("Question \(tapCount)")
                        .font(.headline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth:.infinity)
                    Text("Score: \(userScore)")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 32)
                .padding(.horizontal, 16)
            }
        }
        .alert(isPresented: $showingScore) {
            switch activeAlert {
            case .correct:
                return Alert(title: Text("Correct!"), message: Text("Yup this is the flag of \(tappedFlag). You've got 10 Points!"), dismissButton: .default(Text("Next Question"), action: self.nextQuestion))
            case .wrong:
                return Alert(title: Text("Wrong!"), message: Text("Bad luck, This is the flag of \(tappedFlag)."), dismissButton: .default(Text("Next Question"), action: self.nextQuestion))
            case .result:
                return Alert(title: Text("Final Score"), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Play Again"), action: self.resetGame))
            case .none:
                return Alert(title: Text("Failed"))
            }
        }
    }
    
    func flagTapped (_ number: Int) {
        tapCount += 1
        
        if number == correctAnswer {
            tappedFlag = countries[correctAnswer]
            activeAlert = .correct
            userScore += 10
            withAnimation {
                gradAnimate = true
            }
        } else {
            tappedFlag = countries[number]
            activeAlert = .wrong
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
            activeAlert = .result
        }
        showingScore = true
    }
    
    func nextQuestion () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        gradAnimate = true
    }
    func resetGame () {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tapCount = 0
        userScore = 0
        showingScore = false
        gradAnimate = true
    }
}

#Preview {
    ContentView()
}
