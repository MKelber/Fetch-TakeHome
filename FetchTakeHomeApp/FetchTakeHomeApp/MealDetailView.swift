//
//  MealDetailView.swift
//  FetchTakeHomeApp
//
//

import Foundation
import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @State private var detailedMeal: DetailedMeal?
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            if isLoading{
                ProgressView()
            }else if let meal = detailedMeal{
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    
                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding([.leading,.trailing])

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ingredients")
                            .font(.title)
                            .padding([.leading, .trailing, .top])
                        
                        ForEach(meal.ingredients, id: \.0) { ingredient, measure in
                            HStack{
                                Text(ingredient)
                                Spacer()
                                Text(measure)
                            }
                            .padding([.leading,.trailing])
                        }
                        
                    }
                                        
                    VStack(alignment: .leading) {
                        Text("Instructions")
                            .font(.title)
                            .padding([.leading,.trailing])
                        
                        ForEach(meal.strInstructions.split(separator: "\r\n"), id: \.self) {paragraph in
                            Text(paragraph.trimmingCharacters(in: .whitespacesAndNewlines))
                                .padding([.leading,.trailing,.bottom])
                        }
                    }
                    

                    Spacer()
                }
            } else {
                Text("Failed to load meal details")
            }
        }
        .onAppear {
            fetchDetailedMeal()
        }
    }

    private func fetchDetailedMeal() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(meal.id)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let detailedMealResponse = try JSONDecoder().decode(DetailedMealResponse.self, from: data)
                if let detailedMeal = detailedMealResponse.meals.first {
                    DispatchQueue.main.async {
                        self.detailedMeal = detailedMeal
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: Meal(name: "", thumbnail: "", id: "52772"))
    }
}
