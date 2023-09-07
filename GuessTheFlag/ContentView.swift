//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Seymen Özdeş on 6.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var wrongAnswer = 0
    @State private var isOver: Bool = false
    @State private var tapCount: Int = 0
    @State private var endTitle: String = "End Game"
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"] .shuffled()
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            tapCount += 1
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
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
                .alert(endTitle,isPresented: $isOver) {
                    Button("Game over", action: reset)
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
        // Oyunu sıfırlar
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
