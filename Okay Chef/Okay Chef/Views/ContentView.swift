
//  ContentView.swift
//  Okay Chef
//  Created by Alexsa Tolentino on 11/22/23.
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack{
                List{
                    Text("Hello")
                }
                
            }
            .navigationTitle("Desserts")
            .padding(.top, 14.0)
            .background(Color.accentColor)
        }
    }
}
#Preview {
    ContentView()
}

struct Dessert: Codable {
    let id: String
    let name: String
    let instructions: String
    let ingredients: [String]
}
