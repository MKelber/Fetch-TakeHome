//
//  ApiModels.swift
//  FetchTakeHomeApp
//
//

import Foundation

struct Meal: Codable, Identifiable {
    let name: String
    let thumbnail: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case name = "strMeal"
        case thumbnail = "strMealThumb"
        case id = "idMeal"
    }
}

struct MealResponse: Codable {
    let meals: [Meal]
}

struct DetailedMeal: Codable {
    let idMeal: String
    let strMeal: String
    let strDrinkAlternate: String?
    let strCategory: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strTags: String?
    let strYoutube: String?
    
    private let strIngredient1: String?
    private let strIngredient2: String?
    private let strIngredient3: String?
    private let strIngredient4: String?
    private let strIngredient5: String?
    private let strIngredient6: String?
    private let strIngredient7: String?
    private let strIngredient8: String?
    private let strIngredient9: String?
    private let strIngredient10: String?
    private let strIngredient11: String?
    private let strIngredient12: String?
    private let strIngredient13: String?
    private let strIngredient14: String?
    private let strIngredient15: String?
    private let strIngredient16: String?
    private let strIngredient17: String?
    private let strIngredient18: String?
    private let strIngredient19: String?
    private let strIngredient20: String?
    
    private let strMeasure1: String?
    private let strMeasure2: String?
    private let strMeasure3: String?
    private let strMeasure4: String?
    private let strMeasure5: String?
    private let strMeasure6: String?
    private let strMeasure7: String?
    private let strMeasure8: String?
    private let strMeasure9: String?
    private let strMeasure10: String?
    private let strMeasure11: String?
    private let strMeasure12: String?
    private let strMeasure13: String?
    private let strMeasure14: String?
    private let strMeasure15: String?
    private let strMeasure16: String?
    private let strMeasure17: String?
    private let strMeasure18: String?
    private let strMeasure19: String?
    private let strMeasure20: String?
    
//  consolidate ingredients and their measurements while omitting empty fields
    var ingredients: [(String,String)] {
        var output: [(String,String)] = []
        let mirror = Mirror(reflecting: self)
        
        for index in 1...20 {
            if let ingredient = mirror.children.first(where: {$0.label == "strIngredient\(index)"})?.value as? String, !ingredient.isEmpty,
               let measure = mirror.children.first(where: {$0.label == "strMeasure\(index)"})?.value as? String, !measure.isEmpty {
                output.append((ingredient, measure))
            }
        }
        return output
    }
}

struct DetailedMealResponse: Codable {
    let meals: [DetailedMeal]
}
