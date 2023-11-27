//////
//////  ContentView.swift
//////  Okay Chef
//////
//////  Created by Alexsa Tolentino .
//////
// import SwiftUI
//
////MODELS
//
//struct Meal:  Codable, Identifiable {
//       let idMeal: String
//        let strMeal: String
//        let strMealThumb: String
//    
//    var id: String { idMeal }
//}
//
//struct Category: Codable, Identifiable {
//    let idCategory: String
//    let strCategory: String
//    let strCategoryThumb: String
//    
//    var id: String { idCategory }
//}
//
////RESPONSES
//
//struct MealsResponse: Codable {
//    let meals: [Meal]
//}
//
//struct CategoriesResponse: Codable {
//    let categories: [Category]
//}
//
//
////FETCH
//
////DESSERT
//class ViewModel: ObservableObject {
//    @Published var meals: [Meal] = []
//    
//    func fetchMeals() {
//        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else {
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//                   if let error = error {
//                       print("Error")
//                       return
//                   }
//                   
//                   guard let data = data else {
//                       return
//                   }
//                   
//                   do {
//                       let response = try JSONDecoder().decode(MealsResponse.self, from: data)
//                       DispatchQueue.main.async {
//                           self.meals = response.meals
//                       }
//                   } catch {
//                       print("Error")
//                   }
//               }.resume()
//           }
//       }
//
////CATEGORY
//class CategoryViewModel: ObservableObject {
//    @Published var categories: [Category] = []
//    
//    func fetchCategories() {
//        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                print("Error")
//                return
//            }
//            
//            guard let data = data else {
//                print("No category data received")
//                return
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(CategoriesResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self.categories = response.categories
//                }
//            } catch {
//                print("Error")
//            }
//        }.resume()
//    }
//}
//
////CATEGORIES VIEW
//struct CategoryListView: View {
//    @StateObject var viewModel = CategoryViewModel()
//    var body: some View {
//           NavigationView {
//               List(viewModel.categories) { category in
//                   NavigationLink(destination: DessertListView(category: category)) {
//                       HStack {
//                           AsyncImage(url: URL(string: category.strCategoryThumb)) { image in
//                               image.resizable().aspectRatio(contentMode: .fill).frame(width: 50, height: 50).cornerRadius(8)
//                           } placeholder: {
//                               ProgressView()
//                           }
//        
//                           Text(category.strCategory)
//                       }
//                   }
//               }
//               .navigationTitle("Categories")
//           }
//           .onAppear {
//               viewModel.fetchCategories()
//           }
//       }
//   }
//
//
//
//
//
//
////DESSERT VIEW
//struct DessertListView: View {
//    let category: Category
//    @StateObject var viewModel = ViewModel()
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.meals) { meal in
//                NavigationLink(destination: DetailView(meal: meal)) {
//                    HStack {
//                        //IMAGES
//                        AsyncImage(url: URL(string: meal.strMealThumb)) { image in
//                                image.resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 70, height: 50)
//                                .cornerRadius(8)
//                            } placeholder: {
//                            ProgressView()
//                        }
//                        //TEXT
//                        Text(meal.strMeal)
//                    }
//                }
//            }
//            .navigationTitle("Desserts")
//        }
//        .onAppear {
//            viewModel.fetchMeals()
//        }
//    }
//}
//
////DETAIL VIEW
//
//struct DetailView: View {
//    let meal: Meal
//    
//    var body: some View {
//        VStack {
//            Text(meal.strMeal)
//            // Add more details or UI components for the selected dessert
//        }
//        .navigationTitle(meal.strMeal)
//    }
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
////PREVIEW
//struct ContentView_Preview: PreviewProvider{
//    static var previews: some View {
//        CategoryListView()
//    }
//}
