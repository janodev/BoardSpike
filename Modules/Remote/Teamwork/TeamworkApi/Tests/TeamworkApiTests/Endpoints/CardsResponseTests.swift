import Foundation
@testable import TeamworkApi
import XCTest

// swiftlint:disable force_try force_unwrapping
final class CardsResponseTests: XCTestCase {
    
    static var allTests = [
        ("testCardsResponse", testCardsResponse)
    ]
    
    func testCardsResponse() {
        
        let jsonData = cards_json.data(using: .utf8)!
        let cardsResponse = try! JSONDecoder().decode(CardsResponse.self, from: jsonData)
        let cards = cardsResponse.cards
        print(cards as Any)
    }
}
