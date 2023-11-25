//  OkayChef
//  Created by Alexsa Tolentino on 11/22/23.
//

import SwiftUI


struct DessertView: View {
    @StateObject private var viewModel = DessertViewModel()
    
    var body: some View {
        NavigationView {
            VStack{
                List(viewModel.desserts, id: \.idMeal) { dessert in
                        HStack {
                            if let imageURL = URL(string: dessert.strMealThumb),
                               let imageData = try? Data(contentsOf: imageURL),
                               let uiImage = UIImage(data: imageData) {
                                Image (uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 100)
                                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                            }
                            Text(dessert.strMeal)
                        }
                    }
                }
            .onAppear {
                viewModel.fetchDesserts()
            }
        }
    }
}



//PREVIEW
struct DessertView_Previews: PreviewProvider{
    static var previews: some View {
        DessertView()
    }
}

