@testable import UI
import XCTest

final class CharacterDraggableSource: DraggableSource {

    var items = [NSString]()
    
    init(items: [NSString]) {
        
        self.items = items
    }
}

final class DraggableSourceTests: XCTestCase
{
//    static var allTests = [
//        ("testCount", testCount)
//    ]
    
    private let initialItems: [NSString] = ["a", "b", "c"]
    private var source = CharacterDraggableSource(items: [])
    
    override func setUp() {
        source = CharacterDraggableSource(items: initialItems)
    }

    func testCount() {
        XCTAssertEqual(source.count, 3)
    }
    
    func testItems() {
        XCTAssertEqual(source.items, initialItems)
    }
    
    func testAppendItems() {
        source.append(CollectionOfOne("d"))
        XCTAssertEqual(source.items, ["a", "b", "c", "d"])
    }
    
    func testAppendItem() {
        source.append("d")
        XCTAssertEqual(source.items, ["a", "b", "c", "d"])
    }
    
    // inserting at a item that doesn’t exist crashes
    func testInsertItemAtOtherItem() {
        let source1 = CharacterDraggableSource(items: CollectionOfOne("a"))
        source1.insert("b", at: "a")
        XCTAssertEqual(source1.items, ["b", "a"])
        
        let source2 = CharacterDraggableSource(items: ["a", "b"])
        source2.insert("c", at: "b")
        XCTAssertEqual(source2.items, ["a", "c", "b"])
    }
    
    func testInsertItemAtRow() {
        let source1 = CharacterDraggableSource(items: CollectionOfOne("a"))
        source1.insert("b", at: 0)
        XCTAssertEqual(source1.items, ["b", "a"])
        
        let source2 = CharacterDraggableSource(items: ["a", "b"])
        source2.insert("c", at: 1)
        XCTAssertEqual(source2.items, ["a", "c", "b"])
    }
    
    // reading at a index that doesn’t exist crashes
    func testItemAtRow() {
        let source = CharacterDraggableSource(items: CollectionOfOne("a"))
        let item = source.item(at: 0)
        XCTAssertEqual(item, "a")
    }
    
    func testMoveItemAfterItem() {
        let source = CharacterDraggableSource(items: ["a", "b"])
        source.moveItem("a", afterItem: "b")
        XCTAssertEqual(source.items, ["b", "a"])
    }
    
    func testMoveItemBeforeItem() {
        let source = CharacterDraggableSource(items: ["a", "b"])
        source.moveItem("b", beforeItem: "a")
        XCTAssertEqual(source.items, ["b", "a"])
    }
    
    func testRemoveAtRow() {
        let source = CharacterDraggableSource(items: ["a", "b"])
        source.remove(at: 0)
        XCTAssertEqual(source.items, ["b"])
    }
    
    func testRemoveElements() {
        let source = CharacterDraggableSource(items: ["a", "b", "c"])
        source.remove(["a", "c"])
        XCTAssertEqual(source.items, ["b"])
    }
    
    func testRemoveItem() {
        let source = CharacterDraggableSource(items: ["a", "b", "c"])
        source.remove("b")
        XCTAssertEqual(source.items, ["a", "c"])
    }
    
    func testRowForItem() {
        let source = CharacterDraggableSource(items: ["a", "b", "c"])
        let row = source.row(for: "b")
        XCTAssertEqual(row, 1)
    }
    
    func testRowsForItems() {
        let source = CharacterDraggableSource(items: ["a", "b", "c"])
        let rows = source.rows(for: ["a", "c"])
        XCTAssertEqual(rows, [0, 2])
    }
}
