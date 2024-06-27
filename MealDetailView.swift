import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @State private var detailedMeal: DetailedMeal?
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let detailedMeal = detailedMeal {
                AsyncImage(url: URL(string: detailedMeal.strMealThumb)) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Text(detailedMeal.strMeal)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(detailedMeal.strInstructions)
                    .font(.body)
                    .multilineTextAlignment(.leading)

                Spacer()
            } else {
                ProgressView()
                    .onAppear {
                        fetchDetailedMeal()
                    }
            }
        }
        .padding()
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
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
        MealDetailView(meal: Meal(name: "Chicken Alfredo", thumbnail: "https://www.example.com/image.jpg", id: 52772))
    }
}