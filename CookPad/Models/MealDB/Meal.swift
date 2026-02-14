//
//  Meal.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import Foundation

enum DecodingError: Error {
    case invalidData(String)
}

struct Meals: Decodable {
    let meals: [Meal]?
}

struct Meal: Decodable, Identifiable, Equatable {
    var id: String
    var name: String
    var category: String?
    var thumbnail: String
    var instructions: String?
    var ingredients : [String] = []
    var measures : [String] = []
    var ytUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case category = "strCategory"
        case thumbnail = "strMealThumb"
        case instructions = "strInstructions"
        case ytUrl = "strYoutube"
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    init(id: String, name: String, category: String?, thumbnail: String, ingredients: [String], measures: [String], instructions: String?, ytUrl: String?) {
        self.id = id
        self.name = name
        self.category = category
        self.thumbnail = thumbnail
        self.ingredients = ingredients
        self.instructions = instructions
        self.ytUrl = ytUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try? container.decode(String.self, forKey: .category)
        thumbnail = try container.decode(String.self, forKey: .thumbnail)
        instructions = try? container.decode(String.self, forKey: .instructions)
        ytUrl = try? container.decode(String.self, forKey: .ytUrl)
        
        var ing = [String?]()
        ing.append(try? container.decode(String.self, forKey: .strIngredient1))
        ing.append(try? container.decode(String.self, forKey: .strIngredient2))
        ing.append(try? container.decode(String.self, forKey: .strIngredient3))
        ing.append(try? container.decode(String.self, forKey: .strIngredient4))
        ing.append(try? container.decode(String.self, forKey: .strIngredient5))
        ing.append(try? container.decode(String.self, forKey: .strIngredient6))
        ing.append(try? container.decode(String.self, forKey: .strIngredient7))
        ing.append(try? container.decode(String.self, forKey: .strIngredient8))
        ing.append(try? container.decode(String.self, forKey: .strIngredient9))
        ing.append(try? container.decode(String.self, forKey: .strIngredient10))
        ing.append(try? container.decode(String.self, forKey: .strIngredient11))
        ing.append(try? container.decode(String.self, forKey: .strIngredient12))
        ing.append(try? container.decode(String.self, forKey: .strIngredient13))
        ing.append(try? container.decode(String.self, forKey: .strIngredient14))
        ing.append(try? container.decode(String.self, forKey: .strIngredient15))
        ing.append(try? container.decode(String.self, forKey: .strIngredient16))
        ing.append(try? container.decode(String.self, forKey: .strIngredient17))
        ing.append(try? container.decode(String.self, forKey: .strIngredient18))
        ing.append(try? container.decode(String.self, forKey: .strIngredient19))
        ing.append(try? container.decode(String.self, forKey: .strIngredient20))
        ingredients = ing.compactMap{ $0 }.filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        var meas = [String?]()
        meas.append(try? container.decode(String.self, forKey: .strMeasure1))
        meas.append(try? container.decode(String.self, forKey: .strMeasure2))
        meas.append(try? container.decode(String.self, forKey: .strMeasure3))
        meas.append(try? container.decode(String.self, forKey: .strMeasure4))
        meas.append(try? container.decode(String.self, forKey: .strMeasure5))
        meas.append(try? container.decode(String.self, forKey: .strMeasure6))
        meas.append(try? container.decode(String.self, forKey: .strMeasure7))
        meas.append(try? container.decode(String.self, forKey: .strMeasure8))
        meas.append(try? container.decode(String.self, forKey: .strMeasure9))
        meas.append(try? container.decode(String.self, forKey: .strMeasure10))
        meas.append(try? container.decode(String.self, forKey: .strMeasure11))
        meas.append(try? container.decode(String.self, forKey: .strMeasure12))
        meas.append(try? container.decode(String.self, forKey: .strMeasure13))
        meas.append(try? container.decode(String.self, forKey: .strMeasure14))
        meas.append(try? container.decode(String.self, forKey: .strMeasure15))
        meas.append(try? container.decode(String.self, forKey: .strMeasure16))
        meas.append(try? container.decode(String.self, forKey: .strMeasure17))
        meas.append(try? container.decode(String.self, forKey: .strMeasure18))
        meas.append(try? container.decode(String.self, forKey: .strMeasure19))
        meas.append(try? container.decode(String.self, forKey: .strMeasure20))
        measures = meas.compactMap{ $0 }.filter { !$0.replacingOccurrences(of: " ", with: "").isEmpty }
        
        if ingredients.count != measures.count {
            throw DecodingError.invalidData("Number of ingredients and measures do not match")
        }
         
    }
}

