
import SwiftUI

//MODELS

struct Dessert:  Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct MealDetails: Codable {
    let strMeal: String
    let strCategory: String
    let strInstructions: String
}

extension MealDetails {
    var ingredients: [String] {
        var ingredientsArray = [String]()
        Mirror(reflecting: self).children.forEach { (label, value) in
            if let ingredient = value as? String, !ingredient.isEmpty {
                ingredientsArray.append(ingredient)
            }
        }
        return ingredientsArray
    }
}









//FETCH

class NetworkManager: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var selectedMeal: MealDetails?
    
    func fetchDesserts(){
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("No Data")
                return
            }
            do {
                let response = try JSONDecoder().decode([String: [Dessert]].self, from: data)
                if let desserts = response["meals"] {
                    DispatchQueue.main.async {
                        self.desserts = desserts
                    }
                }
            } catch {
                print("GIRRRLL ERROR")
            }
        }.resume()
    }
    
  
    func fetchMealDetails(for dessert: Dessert) {
        guard let url = URL(string:"https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(dessert.idMeal)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("uh oh")
                return
            }
            
            do {
                let response = try JSONDecoder().decode([String: [MealDetails]].self, from: data)
                print(response)
                if let mealDetails = response["meals"]?.first {
                    DispatchQueue.main.async {
                        self.selectedMeal = mealDetails
                
                    }
                }
            } catch {
                print("Error Error")
            }
        }.resume()
    }
}


struct SwiftUIView: View {
    @StateObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.desserts) { dessert in
                NavigationLink(destination: DetailView(networkManager: networkManager, dessert: dessert)) {
                    Text(dessert.strMeal)
                }
            }
            .navigationTitle("Desserts")
        }
        .onAppear{
            networkManager.fetchDesserts()
        }
    }
}

struct DetailView: View {
    @ObservedObject var networkManager: NetworkManager
    let dessert: Dessert

    var body: some View {
        VStack {
            if let meal = networkManager.selectedMeal {
                Text("Meal Name: \(meal.strMeal)")
                Text("Category: \(meal.strCategory)")
                Text("Instructions: \(meal.strInstructions)")
                // Display other meal details here
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




//PREVIEW
struct SwiftUI_Preview: PreviewProvider{
    static var previews: some View {
     SwiftUIView()
    }
}
