
import SwiftUI

struct ContentView: View {
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


//PREVIEW
struct ContentView_Preview: PreviewProvider{
    static var previews: some View {
     ContentView()
    }
}
