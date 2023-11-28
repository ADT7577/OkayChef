
import SwiftUI

struct CategoryView: View {
    @StateObject var networkManager: NetworkManager

    
    var body: some View {
    NavigationView {
          List(networkManager.categories) { category in
            NavigationLink(destination: DessertView(networkManager: networkManager)) {
                HStack{
                    Text(category.strCategory)
                }
            }
            
        }
        .navigationTitle("Categories")
    }
    .onAppear {
        networkManager.fetchCategory()
      }
    }
}



struct CategoryView_Preview: PreviewProvider{
    static var previews: some View {
      EmptyView()
    }
}
