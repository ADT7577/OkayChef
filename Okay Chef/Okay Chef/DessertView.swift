
//

import SwiftUI

struct DessertView: View {
    @StateObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.desserts) { dessert in
                NavigationLink(destination: DetailView(networkManager: networkManager, dessert: dessert)) {
                    HStack {
                        Text(dessert.strMeal)
                            .bold()
                    }
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

struct DessertView_Preview: PreviewProvider{
    static var previews: some View {
    EmptyView()
    }
}

