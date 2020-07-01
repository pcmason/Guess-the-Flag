//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Paul Mason on 6/30/20.
//  Copyright © 2020 Paul Mason. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //add a variable to track the users score
    @State private var userScore = 0
    //add State properties used to show score after the user selects a flag
    //first a bool variable to determine if the alert should be shown
    @State private var showingScore = false
    //add property that will store title that will be shown inside the alert
    @State private var scoreTitle = ""
    //first create an array of all the country images we will show in the game
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    //create an integer for storing which country image is correct
    @State private var correctAnswer = Int.random(in: 0...2)
    var body: some View {
        //add a ZStack to make the background color blue
        ZStack {
            //make the background a linearGradient of blue and black so the flags stand out better
            LinearGradient(gradient: Gradient(colors: [.blue, .black]),startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                //lay out game prompt in a VStack
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(Color.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(Color.white)
                }
                //now insert tappable flag buttons
                ForEach(0 ..< 3){ number in
                    Button(action: {
                        self.flagTapped(number)
                    }){
                        Image(self.countries[number]).renderingMode(.original)
                        //renderingMode tells Swift not to attempt to recolor our buttons
                        //clipshapeCapsule makes our buttons look like a capsule
                        .clipShape(Capsule())
                        //draw a border around the images using overlay
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                        //add a shadow effect to the flags so they really stand out
                            .shadow(color: .black, radius: 2)
                    }
                }
                VStack {
                    Text("Your score is: \(userScore)")
                        .foregroundColor(Color.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                Spacer()
            }
            //now add the alert that shows the title, user's score and generates a new question once dismissed
                .alert(isPresented: $showingScore){
                    Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")){
                        self.askQuestion()
                    })
                }
        }
            
    }
    //function called whenever a flag was checked and sets the alert bool to true to show an alert
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 50
        }else {
            scoreTitle = "Wrong, that is the flag of \(countries[number])"
            if userScore > 0 {
                userScore -= 25
            }
        }
        showingScore = true
    }
    //create function that generates a new question once the user has dismissed the alert
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
