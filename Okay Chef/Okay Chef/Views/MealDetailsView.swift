//
//  MealDetails.swift
//  Okay Chef
//
//  Created by Alexsa Tolentino on 11/27/23.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var networkManager: NetworkManager
    let dessert: Dessert
    
    var body: some View {
        VStack {
            if let meal = networkManager.selectedMeal {
                Text("\(meal.strMeal)")
                Text("\(meal.strInstructions)")
                Text("Ingredients:")
                 List {
                    ForEach(0..<min(meal.ingredients.count, meal.measurements.count), id: \.self) { index in
                        Text("\(meal.measurements[index]) \(meal.ingredients[index])")
                    }
                }
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            networkManager.fetchMealDetails(for: dessert)
        }
        .navigationTitle("Meal Details")
    }
}

struct MealDetailsView_Preview: PreviewProvider{
    static var previews: some View {
    EmptyView()
    }
}
