////
////  ContentView.swift
////  Okay Chef
////
////  Created by Alexsa Tolentino on 11/25/23.
////
 import SwiftUI


struct Meal:  Codable, Identifiable {
       let idMeal: String
        let strMeal: String
        let strMealThumb: String
    
    var id: String { idMeal }
}

struct MealsResponse: Codable {
    let meals: [Meal]
}

class ViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    
    func fetchMeals() {
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
                   if let error = error {
                       print("Error fetching data: \(error.localizedDescription)")
                       return
                   }
                   
                   guard let data = data else {
                       return
                   }
                   
                   do {
                       let response = try JSONDecoder().decode(MealsResponse.self, from: data)
                       DispatchQueue.main.async {
                           self.meals = response.meals
                       }
                   } catch {
                       print("Error")
                   }
               }.resume()
           }
       }

struct DessertListView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: DetailView(meal: meal)) {
                    Text(meal.strMeal)
                }
            }
            .navigationTitle("Desserts")
        }
        .onAppear {
            viewModel.fetchMeals()
        }
    }
}


struct DetailView: View {
    let meal: Meal
    
    var body: some View {
        VStack {
            Text(meal.strMeal)
            // Add more details or UI components for the selected dessert
        }
        .navigationTitle(meal.strMeal)
    }
}


struct ContentView_Preview: PreviewProvider{
    static var previews: some View {
        DessertListView()
    }
}
