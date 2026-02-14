//
//  CookPadTests.swift
//  CookPadTests
//
//  Created by Mariano Arselan on 30-01-26.
//

import Foundation
import Testing
@testable import CookPad

class SomeClass {
    @Capitalized var text: String = "hello"
}

struct CookPadTests {

    @Test func testCapitalized() async throws {
        var sut = SomeClass()
        #expect(sut.text == "Hello")
        
        
    }
    
    @Test func testMealDecoder() {
        let sut = "{\"meals\": [ {\"idMeal\": \"id\", \"strMeal\": \"name\", \"strCategory\": \"category\", \"strMealThumb\": \"http://some-url.com\", \"strInstructions\": \"\", \"strYoutube\": \"\"}] }"
        let expected = Meal(id: "id", name: "name", category: "category", thumbnail: "http://some-url.com", ingredients: [], measures: [], instructions: "", ytUrl: "")
        let decoder = JSONDecoder()
        let json = try? decoder.decode(Meals.self, from: sut.data(using: .utf8)!)
        #expect(json != nil)
        #expect(json!.meals![0] == expected)
    }
    
    @Test func testMealDecoderMinimumResponse() {
        let sut = "{\"meals\": [ {\"idMeal\": \"id\", \"strMeal\": \"name\", \"strMealThumb\": \"http://some-url.com\" }] }"
        let expected = Meal(id: "id", name: "name", category: nil, thumbnail: "http://some-url.com", ingredients: [], measures: [], instructions: nil, ytUrl: nil)
        let decoder = JSONDecoder()
        let json = try? decoder.decode(Meals.self, from: sut.data(using: .utf8)!)
        #expect(json != nil)
        #expect(json!.meals![0] == expected)
    }
}
