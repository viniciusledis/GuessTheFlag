
//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Vinicius Ledis on 24/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var paises = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var respostaCerta = Int.random(in: 0...2)
    @State private var score = Int()
    @State private var maxScore = Int()
    
    @State private var pontuacaoAlerta = false
    @State private var scoreTitle = ""
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var animationAmount = 0.0
    @State private var opacidades = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
                ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess The Flag!")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack (spacing: 15) {
                    VStack {
                        Text("Escolha a bandeira correta:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(paises[respostaCerta])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        withAnimation {
                            Button {
                                animationAmount += 360
                                flagTapped(number)
                            } label: {
                                Image(paises[number])
                                    .clipShape(.capsule)
                                    .shadow(radius: 5)
                                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                                    .opacity(opacidades[number])
                            }
                            .accessibilityLabel(labels[paises[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                
                Spacer()
                Spacer()
                
                Text("Recorde: \(maxScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $pontuacaoAlerta) {
            Button("Continuar", action: askQuestion)
        } message: {
            Text("Sua pontuação é: \(score)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == respostaCerta {
            scoreTitle = "Correto!"
            score += 1
            if score > maxScore {
                maxScore = score
            }
        } else {
            scoreTitle = "Errado!"
            if score > maxScore {
                maxScore = score
            }
            score = 0
        }
        
        opacidades = opacidades.enumerated().map { (index, _) in
                        return index == respostaCerta ? 1.0 : (index == number ? 0.6 : opacidades[index])
                    }
        
        pontuacaoAlerta = true
        
    }
    
    func askQuestion() {
        paises.shuffle()
        respostaCerta = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
