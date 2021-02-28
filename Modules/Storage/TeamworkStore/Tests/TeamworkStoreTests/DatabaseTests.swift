
@testable import TeamworkStore
import XCTest

final class BikiniAppTests: XCTestCase
{
    let company = Company(id: 0, name: "Beforeigners")
    let redTag = Tag(color: "#FF0000", id: 0, name: "Red", projectId: 0)
    let ellenAvatarUrl = URL(string: "http://domain/alice.png")!
    lazy var ellen = Person(id: 0,
                            name: "Ellen",
                            company: company,
                            avatarUrl: ellenAvatarUrl,
                            firstName: "Ellen",
                            lastName: "Page")
    
    func testDatabase()
    {
        let card = Card(
            id: 0,
            columnId: 0,
            name: "Jump in the fire",
            assignedPeople: [ellen],
            tags: [redTag]
        )
        let database = Database.read()
        database.cards = [card]

        let databaseAgain = Database.read()
        XCTAssert(!databaseAgain.cards.isEmpty)
    }
}
