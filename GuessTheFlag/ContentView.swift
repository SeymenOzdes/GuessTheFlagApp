//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Seymen Özdeş on 6.09.2023.
//

import SwiftUI

struct flagImage: View {
    var input: String
    
    var body: some View {
        Image(input)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}
struct titleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.blue)
    }
}
extension View {
    func titleStyle() -> some View {
        modifier(titleModifier())
    }
}

struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"] .shuffled()
    @State private var endTitle: String = "End Game"
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var tapCount: Int = 0
    @State private var wrongAnswer = 0
    @State private var score = 0
    @State private var showingScore: Bool = false
    @State private var isOver: Bool = false
    
    @State private var degrees = Double.zero

    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .titleStyle()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .titleStyle()
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            tapCount += 1
                            degrees = (degrees == .zero) ? 360 : .zero
                        }label: {
                            flagImage(input: countries[number])
                        }
                        .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
                        .animation(.easeInOut, value: degrees)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                
                VStack {
                    Text("Score: \(tapCount)")
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                }
                .alert(endTitle, isPresented: $isOver) {
                    Button("Game Over", action: reset)
                } message: {
                    if tapCount == 9 {
                        Text("End game, your score: \(score)")
                    }
                }
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if scoreTitle == "Wrong" {
                Text("Wrong! That’s the flag of \(countries[wrongAnswer])")
            }
            else {
                Text("Your score is \(score)")
            }
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        }
        else if number != correctAnswer {
            wrongAnswer = number
            scoreTitle = "Wrong"
            score -= 1
        }
        showingScore = true
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    func reset() {
        // Reset game
        score = 0
        scoreTitle = ""
        showingScore = false
        isOver = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
