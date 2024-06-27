//
//  MealListView.swift
//  FetchTakeHomeApp
//
//

import Foundation
import SwiftUI

struct MealListView: View {
    @State private var meals: [Meal] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            List(meals.sorted { $0.name < $1.name }) { meal in
                NavigationLink(destination: MealDetailView(meal: meal)) {
                    HStack {
                        AsyncImage(url: URL(string: meal.thumbnail)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())

                        Text(meal.name)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Desserts")
            .onAppear {
                fetchDesserts()
            }
        }
    }

    private func fetchDesserts() {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let mealResponse = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    self.meals = mealResponse.meals
                    self.isLoading = false
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
    }
}
