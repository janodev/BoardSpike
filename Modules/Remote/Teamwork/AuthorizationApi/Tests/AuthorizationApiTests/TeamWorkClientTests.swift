import Foundation
@testable import Networking
import XCTest

// swiftlint:disable force_unwrapping
final class TeamWorkClientTests: XCTestCase {

    static var allTests = [
        ("testProjects", testProjects),
        ("testColumns", testColumns),
        ("testTasks", testTasks),
        ("testcreateColumn", testcreateColumn)
    ]
    
    private let company = "testingtheiosappwithanemptyprojectinc"
    private let apiToken = "twp_I7FulSTjVhfQz78p9ov2XQj8y2Tc_eu"
    private let baseURL = URL(string: "https://testingtheiosappwithanemptyprojectinc.eu.teamwork.com")!
    private let timeout = 4.0

    private func client(file: String) -> TeamWorkClient {
        let httpUrlResponse = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [:])
        let session = SessionStub(data: Data(file.utf8),
                                  response: httpUrlResponse,
                                  error: nil)
        let apiClient = ApiClient(baseURL: baseURL, session: session)
        let provider = AuthorizationProvider(company: company, apiToken: apiToken)
        return TeamWorkClient(apiClient: apiClient, authProvider: provider)
    }
    
    func testProjects() {
        let exp = expectation(description: "Read the projects")
        client(file: projects_json).projects { result in
            if case let .success(response) = result, let projects = response.projects {
                XCTAssertEqual(projects.count, 2)
                XCTAssertEqual(projects[0].name, "Costa Rica 4k")
                XCTAssertEqual(projects[1].name, "Mobile Design")
            } else {
                XCTFail("Expected a success.")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }
    
    func testColumns() {
        let exp = expectation(description: "Read the columns")
        client(file: columns_json).columns(projectId: "468919") { result in
            if case let .success(columnsResponse) = result {
                let columns = columnsResponse.columns
                XCTAssertEqual(columns.count, 3)
                XCTAssertEqual(columns[0].name, "To do")
                XCTAssertEqual(columns[1].name, "In progress")
                XCTAssertEqual(columns[2].name, "Done")
            } else {
                XCTFail("Expected a success.")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }
    
    func testTasks() {
        let exp = expectation(description: "Read the tasks")
        client(file: tasks_json).tasks(projectId: "468919") { result in
            switch result {
            case .success(let tasksResponse):
                let todoItems = tasksResponse.todoItems
                XCTAssertEqual(todoItems.count, 1)
                XCTAssertEqual(todoItems[0].description, "Cook a pie and eat it.")
            case .error(let error):
                XCTFail("\(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }

    func testcreateColumn() {
        let exp = expectation(description: "Creates the column")
        let params = NewColumnParams(color: "#27AE60", name: "To do", projectId: "468919")
        client(file: createColumn_json).createColumn(newColumn: params) { result in
            switch result {
            case .success(let createColumnResponse):
                XCTAssertEqual(createColumnResponse.id, "64999")
                XCTAssertEqual(createColumnResponse.status, "OK")
            case .error(let error):
                XCTFail("\(error)")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: timeout)
    }
}
